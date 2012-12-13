require "fomi2inspire/version"

module Fomi2inspire
  require 'rainbow'
  require 'terminal-table'
  require 'progressbar'

  CONFIG_SOFTWARES = "./data/config/softwares.yml"
  CONFIG_CR_USR = "data/setup/create_user_db.yml"
  CONFIG_DROP = "data/setup/drop.yml"
  CONTENT_LENGTH = "content-length"
  USERNAME = "USERNAME"
  PASSWORD = "PASSWORD"
  DATABASE_NAME = "DBNAME"
  POSTGIS_TEMPLATE = "POSTGIS_TEMPLATE"


  #
  # Downloading Files from softwares.yml
  #
  def Fomi2inspire.download(destination)
    require 'yaml'
    require 'net/http'
    config = YAML.load_file(CONFIG_SOFTWARES)
    config.each_pair{ |key, val|
      if URI.parse(val) and File.directory?(destination)
        file = open(File.join(destination, key), "wb")
        uri = URI.parse(val)
        
        begin
          Net::HTTP.start(uri.host, uri.port) do |http|
            response = http.request_head(URI.escape(val))
            pbar = ProgressBar.new(key, response[CONTENT_LENGTH].to_i)
            counter = 0

            request = Net::HTTP::Get.new uri.request_uri
            http.request request do |response|
              response.read_body do |chunk|
                file.write chunk
                counter += chunk.length
                pbar.set(counter)
              end
            end

            pbar.finish
          end
        rescue Exception => e
          puts e
        ensure
          file.close
        end
      end
    }
  end

  #
  # Checking Database, Tables, Schema existance.
  # Tables:
  #   - Feature_types
  #   - Gml_objects
  # Schemas:
  #   - Defined in APP_FOLDER/data/inspire_schemas.txt
  #
  def Fomi2inspire.check_schema_validity?(config, schema_def_file)
    require 'helper/inspirevalidator'
    begin
      validator = InspireValidator.new(config)
      unless validator.inspire_tables?
        puts "Invalid INSPIRE schema in database [#{config[:database]}]\n \t ~> Fix: fomi2inspire setup".foreground(:red)
        self.print_schema_results(false)
        return false
      else
        puts "Valid INSPIRE schema in database: [#{config[:database]}]".foreground(:green)
    		self.print_schema_results(true)
    		schema_def_content = Fomi2inspire.read_file(schema_def_file)
    		if validator.feature_types?(schema_def_content)
    			puts "Matched with given schema definition".foreground(:green)
    			Fomi2inspire.print_capability_results(true, schema_def_content)
    		else
    			puts "Unmatched with given schema definition".foreground(:yellow)
    		end
        return true
      end      
    rescue Exception => e
      puts (e.to_s).foreground(:yellow)
    end
  end

  def Fomi2inspire.drop(config)
    # Creating role and database
    require 'active_support/core_ext'
    require 'yaml'
    require 'helper/database'
    begin
      queries = YAML.load_file(CONFIG_DROP)
      conn = Database.connect(config.slice(:host, :user, :password))
      if config[:dbname]
        puts "Executing: Drop database: #{config[:dbname]} ...".foreground(:green)
        sql = Fomi2inspire.replace(queries[:dropdb], DATABASE_NAME, config[:dbname])
        result = conn.exec(sql)
        puts "\t ~> Database #{config[:dbname]} dropped".foreground(:green)
      else
        puts "Executing: Drop user role: #{config[:usr]} ...".foreground(:green)
        sql = Fomi2inspire.replace(queries[:droprole], USERNAME, config[:usr])
        result = conn.exec(sql)
        puts "\t ~> User #{config[:usr]} dropped".foreground(:green)
      end
    rescue Exception => e
      puts (e.to_s).foreground(:yellow)
    end
  end

  def Fomi2inspire.setup_user(config)
    # Creating role and database
    require 'active_support/core_ext'
    require 'yaml'
    require 'helper/database'

    begin
      # Connect to database
      conn = Database.connect(config.slice(:host, :user, :password))
      # Read create_user_db file and substitute with given parameters
      queries = YAML.load_file(CONFIG_CR_USR)

      puts "Executing: Creating user role: #{config[:usr]} ...".foreground(:green)
      sql =  Fomi2inspire.replace_role_query(queries[:role], config)
      result = conn.exec(sql)
      puts "\t ~> User #{config[:usr]} created with"
      Fomi2inspire.print_role_wrights()          
    rescue Exception => e
      puts (e.to_s).foreground(:yellow)
    end    
  end

  def Fomi2inspire.setup_db(config)
  	# Creating role and database
    require 'active_support/core_ext'
    require 'yaml'
    require 'helper/database'

  	begin
    	# Connect to database
    	conn = Database.connect(config.slice(:host, :user, :password))
    	# Read create_user_db file and substitute with given parameters
  		queries = YAML.load_file(CONFIG_CR_USR)  		

  		puts "Executing: Creating database: #{config[:dbname]}...".foreground(:blue)
  		sql =  Fomi2inspire.replace_db_create_query(queries[:database], config)
  		result = conn.exec(sql)
  		puts "\t ~> Database #{config[:dbname]} created with #{config[:template]} postgis template".foreground(:blue)

  		# Connecting to #{config[:dbname]}
  		conn.close()
  		conn = Database.connect(config.slice(:host, :dbname, :user, :password))
  		# Running grant operations
  		puts "Executing: Grants wrights to #{config[:usr]} role on [#{config[:dbname]}]...".foreground(:yellow)
  		sql = Fomi2inspire.replace_username_query(queries[:grantdatabase], config[:usr], config[:dbname])
  		result = conn.exec(sql)
  		puts "Grant all privileges on database: #{config[:dbname]} to #{config[:usr]}".foreground(:yellow)
  		sql = Fomi2inspire.replace_username_query(queries[:grantcolumn], config[:usr])
  		result = conn.exec(sql)
  		puts "Grant all privileges on geometry_columns to #{config[:usr]}".foreground(:yellow)
  		sql = Fomi2inspire.replace_username_query(queries[:grantgeom], config[:usr])
  		result = conn.exec(sql)
  		puts "Grant all privileges on geography_columns to #{config[:usr]}".foreground(:yellow)
  		sql = Fomi2inspire.replace_username_query(queries[:grantspatref], config[:usr])
  		result = conn.exec(sql)
  		puts "Grant all privileges on spatial_ref_sys to #{config[:usr]}".foreground(:yellow)

      #
      # XSLT table containing xsl documents
      #
      sql = "create table xsl(id serial primary key, name varchar(255), data text);"
      result = conn.exec(sql)
      
  	rescue Exception => e
  		puts (e.to_s).foreground(:yellow)
  	end
  end


  def Fomi2inspire.transform_data(config)
    $LOAD_PATH << '../lib/'
    require 'yaml'
    require 'active_record'
    require 'helper/database.rb'
    require 'helper/transformer.rb'
    require 'model/geographical_name.rb'
    require 'model/administrative_unit.rb'
    require 'model/cadastral_public.rb'
    require 'model/cadastral_private.rb'

    begin
      # Check connection settings
      connections = YAML.load_file(config[:conf])

      # Establishing Database Connection for ActiveRecord
      fomi_con = ActiveRecord::Base.establish_connection(connections[:fomi])
      # Establishing Database Connection for Pg
      inspire_con = Database.new(connections[:inspire])

      if config[:schema] == "Au"
        # Transform Administrative Units
        Fomi2inspire.transform_AU(inspire_con)
      elsif config[:schema] == "Cad"
        # Transform Cadastral Parcels
        Fomi2inspire.transform_Cad(inspire_con)
      else
        # Transform Geographical Names
        Fomi2inspire.transform_Gn(inspire_con)
      end
    rescue Exception => e
      puts (e.to_s).foreground(:yellow)
    end
  end

  def Fomi2inspire.transform_Cad(inspire_con)
    cad = Transformer.new("./data/xsl/CadastralParcels_HU.xsl")
    pbar = ProgressBar.new("CadastralPublic", CadastralPublic.count)
    counter = 0
    CadastralPublic.all.each {|record|
      result = cad.transform_string(record.xml)
      xml = result.to_s(:indent => false).gsub("\n", "")
      query = "insert into gml_objects(gml_id, ft_type, binary_object, gml_bounded_by) values('#{record.parcel_id}-#{record.hrsz}', 6, '#{xml}', ST_GeometryFromText('#{record.env.as_wkt}'))"
      inspire_con.insert(query)
      counter += 1
      pbar.set(counter)
    }
    pbar.finish

    puts "Cadastral Public Imported Records: #{counter}/#{CadastralPublic.count}".foreground(:green)

    pbar = ProgressBar.new("CadastralPrivate", CadastralPrivate.count)
    counter = 0
    CadastralPrivate.all.each {|record|
      result = cad.transform_string(record.xml)
      xml = result.to_s(:indent => false).gsub("\n", "")
      query = "insert into gml_objects(gml_id, ft_type, binary_object, gml_bounded_by) values('#{record.parcel_id}-#{record.hrsz}', 6, '#{xml}', ST_GeometryFromText('#{record.env.as_wkt}'))"
      inspire_con.insert(query)
      counter += 1
      pbar.set(counter)
    }
    pbar.finish
    puts "Cadastral Private Imported Records: #{counter}/#{CadastralPrivate.count}".foreground(:green)
  end

  def Fomi2inspire.transform_AU(inspire_con)
    au = Transformer.new("./data/xsl/AdministrativeUnits_HU.xsl")
    pbar = ProgressBar.new("Administrative Units", AdministrativeUnit.count)
    counter = 0

    au_unit = AdministrativeUnit.first
    result = au.transform_string(au_unit.xml)
    xml = result.to_s(:indent => false).gsub("\n", "")
    AdministrativeUnit.all.each {|record|
      result = au.transform_string(record.xml)
      xml = result.to_s(:indent => false).gsub("\n", "")
      query = "insert into gml_objects(gml_id, ft_type, binary_object, gml_bounded_by) values('#{record.shn}', 1, '#{xml}', ST_GeometryFromText('#{record.env.as_wkt}'))"
      inspire_con.insert(query)
      counter += 1
      pbar.set(counter)
    }
    pbar.finish
    puts "Administrative Units Imported Records: #{counter}/#{AdministrativeUnit.count}".foreground(:green)
  end

  def Fomi2inspire.transform_Gn(inspire_con)
    gn = Transformer.new("./data/xsl/GeographicalNames_HU.xsl")
    pbar = ProgressBar.new("GeographicalNames", GeographicalName.count)
    counter = 0

    GeographicalName.all.each {|record|
      result = gn.transform_string(record.xml)
      xml = result.to_s(:indent => false).gsub("\n", "")
      query = "insert into gml_objects(gml_id, ft_type, binary_object) values(#{record.objectid}, 8, '#{xml}')"
      inspire_con.insert(query)
      counter += 1
      pbar.set(counter)
    }
    pbar.finish
    puts "Geographical Names Imported Records: #{counter}/#{GeographicalName.count}".foreground(:green)
  end

  def Fomi2inspire.print_schema_results(status)
  	table = Terminal::Table.new do |t|
  	  	if status
  		  t << ['Feature_Types', 'exists'.foreground(:green)]
  		  t << ['GML_Objects', 'exists'.foreground(:green)]
  	  	else
  		  t << ['Feature_Types', 'may not exists'.foreground(:yellow)]
  		  t << ['GML_Objects', 'may not exists'.foreground(:yellow)]	  		
  	  	end
  	end
  	puts table
  end

  def Fomi2inspire.print_capability_results(status, schema_content_arr)
  	table = Terminal::Table.new do |t|
  		if status
  			schema_content_arr.each do |line|
  				t << [line, 'valid'.foreground(:green)]
  			end
  		end
  	end
  	puts table
  end

  def Fomi2inspire.print_role_wrights
  	table = Terminal::Table.new do |t|
  		t << ['nosuperuser','OK']
  		t << ['noinherit','OK']
  		t << ['createdb','OK']
  		t << ['login','OK']
  	end
  	puts table
  end

  def Fomi2inspire.read_file(path)
		src_schema = Array.new
		File.open(path, 'r').each_line{|line|
			src_schema.push((line.to_s).strip!)
		}
		return src_schema
  end

  def Fomi2inspire.replace(sql, key, str)
    return sql.gsub!(key, str)
  end

  def Fomi2inspire.replace_role_query(sql, config)
  	replacements = [[USERNAME, config[:usr]], [PASSWORD, config[:pwd]]]
  	replacements.each{|replacement|
  		sql.gsub!(replacement[0], replacement[1])
  	}
  	return sql
  end

  def Fomi2inspire.replace_db_create_query(sql, config)
  	replacements = [[USERNAME, config[:usr]], [DATABASE_NAME, config[:dbname]], [POSTGIS_TEMPLATE, config[:template]]]
  	replacements.each{|replacement|
  		sql.gsub!(replacement[0], replacement[1])
  	}
  	return sql
  end

  def Fomi2inspire.replace_username_query(sql_query, username, dbname = nil)
  	sql = ""
  	unless dbname.nil?
  		sql = (sql_query.gsub!(USERNAME, username)).gsub!(DATABASE_NAME, dbname)
  	else
		sql = sql_query.gsub!(USERNAME, username)
  	end
  	return sql
  end

  def Fomi2inspire.load_xslt()
    data = ''
    File.open("./data/xsl/geonames.xsl"){|f|
      data = f.read
    }
    return data
  end
end
