require "fomi2inspire/version"

module Fomi2inspire
  require 'rainbow'
  require 'terminal-table'
  require 'progressbar'

  CONFIG_SOFTWARES = "./data/config/softwares.yml"
  CONFIG_CR_USR = "data/setup/create_user_db.yml"
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

  def Fomi2inspire.setup_db(config)
  	# Creating role and database
    require 'active_support/core_ext'
    require 'yaml'
    require 'model/model'

  	begin
    	# Connect to database
    	conn = Model.connect(config.slice(:host, :user, :password))
    	# Read create_user_db file and substitute with given parameters
  		queries = YAML.load_file(CONFIG_CR_USR)

  		puts "Executing: Creating user role: #{config[:usr]} ...".foreground(:green)
  		sql =  Fomi2inspire.replace_role_query(queries[:role], config)
  		result = conn.exec(sql)
  		puts "\t ~> User #{config[:usr]} created with"
  		Fomi2inspire.print_role_wrights()
  		

  		puts "Executing: Creating database: #{config[:dbname]}...".foreground(:blue)
  		sql =  Fomi2inspire.replace_db_create_query(queries[:database], config)
  		result = conn.exec(sql)
  		puts "\t ~> Database #{config[:dbname]} created with #{config[:template]} postgis template".foreground(:blue)

  		# Connecting to #{config[:dbname]}
  		conn.close()
  		conn = Model.connect(config.slice(:host, :dbname, :user, :password))
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
