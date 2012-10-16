require 'rubygems'
require 'yaml'
require 'active_record'

$LOAD_PATH << '../lib/'
require 'helper/database.rb'
require 'helper/transformer.rb'
require 'model/fnt.rb'
require 'model/au.rb'
require 'model/cadastralk.rb'
require 'model/cadastralm.rb'

=begin
describe "Transform", "#initialize" do

	it "should initialize and create a stylesheet according to xls" do
		xsl = Transformer.new("./spec/dummy.xsl")
		result = xsl.transform_file("./spec/dummy.xml")
		xsl.class.should_not be(nil)
	end

end
=end

describe "Transform", "#transforming" do
	before do
		@fconfig = YAML.load_file("./data/config/fomi.yml")
		#@iconfig = YAML.load_file("./data/config/inspire.yml")
		@fomi = ActiveRecord::Base.establish_connection(@fconfig)
		#@inspire = ActiveRecord::Base.establish_connection(@iconfig)
		#@fnt = Transformer.new("./spec/geonames.xsl")
		@fnt = Transformer.new("./data/xsl/GeographicalNames_HU.xsl")
		@au = Transformer.new("./data/xsl/AdministrativeUnits_HU.xsl")
		@cad = Transformer.new("./data/xsl/CadastralParcels_HU.xsl")
		#@foss_xsl = Transformer.new("./data/xsl/GeographicalNames.xsl")
	end

	it "should transform fnt record into geonames.xml" do
		begin
			fnt = Fnt.find_by_objectid(4901)
			result = @fnt.transform_string(fnt.xml)
			xml = result.to_s(:indent => false).gsub("\n", "")
			File.open("spec/gml_object.xml","w:UTF-8"){ |f| 
				f.write(result)
			}
			config = {:host => 'localhost', :user => 'inspire', :password => 'inspire', :dbname => 'inspire'}
			con = Database.new(config)
			query = "insert into gml_objects(gml_id, ft_type, binary_object, gml_bounded_by) values('#{fnt.objectid}', 1, '#{xml}', ST_GeometryFromText('#{fnt.env.as_wkt}'))"
			result = con.insert(query)
			puts result
			result.should_not be(nil)

		rescue Exception => e
			puts "-----------------------"
			puts e
			puts "-----------------------"
		end
	end
=begin
	it "should transform au record into auminunits.xml" do
		begin
			admin_units = Au.find_by_objectid(74)
			puts admin_units.data
			result = @au.transform_string(admin_units.data)
			File.open("spec/output3.xml","w:UTF-8"){ |f| 
				f.write(result)
			}
			config = {:host => 'localhost', :user => 'inspire', :password => 'inspire', :dbname => 'inspire'}
			con = Database.new(config)
			query = "insert into gml_objects(gml_id, ft_type, binary_object, gml_bounded_by) values('#{admin_units.shn}', 1, '#{result}', ST_GeometryFromText('#{admin_units.geom.as_wkt}'))"
			result = con.insert(query)
			puts result
			result.should_not be(nil)
		rescue Exception => e
			puts "-----------------------"
			puts e
			puts "-----------------------"
		end
	end

	it "should validate resulted gml by xsd" do
		result = @fnt.validate_file("data/xsd/GeographicalNames.xsd","spec/output2.xml")
		puts result
		result.should_not be(nil)		
	end

	it "should transform cadastral record into cadastral.xml" do
		begin

			kozterulet = Cadastralk.find_by_parcel_id(238)
			maganterulet = Cadastralm.find_by_parcel_id(913)
			result = @cad.transform_string(kozterulet.xml)
			File.open("spec/output4.xml","w:UTF-8"){ |f| 
				f.write(result)
			}
			result = @cad.transform_string(maganterulet.xml)
			File.open("spec/output5.xml","w:UTF-8"){ |f| 
				f.write(result)
			}

			(maganterulet.hrsz).should eq("0188/11")
			(kozterulet.hrsz).should eq("628")
		rescue Exception => e
			puts "-----------------------"
			puts e
			puts "-----------------------"
		end		
	end
=end
end

=begin
describe "Transform", "#load" do

	it "should insert transformed geographicalnames data into database" do
		@fconfig = YAML.load_file("./data/config/fomi.yml")
		@fomi = ActiveRecord::Base.establish_connection(@fconfig)
		@fnt = Transformer.new("./data/xsl/GeographicalNames_HU.xsl")

		config = {:host => 'localhost', :user => 'inspire', :password => 'inspire', :dbname => 'inspire'}
		con = Database.new(config)
		
		Fnt.all.each {|record|
			result = @fnt.transform_string(record.xml)
			query = "insert into gml_objects(gml_id, ft_type, binary_object, gml_bounded_by) values(#{record.objectid}, 8, '#{result}', ST_GeometryFromText('#{record.geometria.as_wkt}'))"
			con.insert(query)
		}
	end

	it "should insert transformed adminunits data into database" do
		@fconfig = YAML.load_file("./data/config/fomi.yml")
		@fomi = ActiveRecord::Base.establish_connection(@fconfig)
		@au = Transformer.new("./data/xsl/AdministrativeUnits_HU.xsl")


		config = {:host => 'localhost', :user => 'inspire', :password => 'inspire', :dbname => 'inspire'}
		con = Database.new(config)
		
		Au.all.each {|record|
			result = @au.transform_string(record.data)
			#query = "insert into gml_objects(gml_id, ft_type, binary_object, gml_bounded_by) values('#{record.shn}', 1, '#{result}', ST_GeometryFromText('#{record.geom.as_wkt}'))"
			query = "insert into gml_objects(gml_id, ft_type, binary_object, gml_bounded_by) values('HU.FOMI.AU.74', 1, '#{xml}', ST_GeometryFromText('#{admin_units.env.as_wkt}'))"
			con.insert(query)
		}
	end

	it "should insert transformed cadastral data into database" do
		@fconfig = YAML.load_file("./data/config/fomi.yml")
		@fomi = ActiveRecord::Base.establish_connection(@fconfig)
		@cad = Transformer.new("./data/xsl/CadastralParcels_HU.xsl")


		config = {:host => 'localhost', :user => 'inspire', :password => 'inspire', :dbname => 'inspire'}
		con = Database.new(config)
		
		Cadastralk.all.each {|record|
			result = @cad.transform_string(record.xml)
			query = "insert into gml_objects(gml_id, ft_type, binary_object, gml_bounded_by) values('#{record.parcel_id}-#{record.hrsz}', 6, '#{result}', ST_GeometryFromText('#{record.geom.as_wkt}'))"
			con.insert(query)
		}

		Cadastralm.all.each {|record|
			result = @cad.transform_string(record.xml)
			query = "insert into gml_objects(gml_id, ft_type, binary_object, gml_bounded_by) values('#{record.parcel_id}-#{record.hrsz}', 6, '#{result}', ST_GeometryFromText('#{record.geom.as_wkt}'))"
			con.insert(query)
		}

	end
end
=end

describe "Transform", "#testing output" do
=begin
	before do
		@fconfig = YAML.load_file("./data/config/fomi.yml")
		@fomi = ActiveRecord::Base.establish_connection(@fconfig)
		@fnt = Transformer.new("./data/xsl/GeographicalNames_HU.xsl")
		@au = Transformer.new("./data/xsl/AdministrativeUnits_HU.xsl")
	end

	it "should initialize and create a stylesheet according to xls" do
		begin
			admin_units = Au.find_by_objectid(74)
			result = @au.transform_string(admin_units.data)
			xml = result.to_s(:indent => false).gsub("\n", "")
			File.open("spec/output3.xml","w:UTF-8"){ |f| 
				f.write(result)
			}


			config = {:host => 'localhost', :user => 'inspire', :password => 'inspire', :dbname => 'inspire'}
			con = Database.new(config)
			#query = "insert into gml_objects(gml_id, ft_type, binary_object, gml_bounded_by) values('HU.FOMI.AU.74', 1, '#{xml}', ST_GeometryFromText('#{(admin_units.geog.bounding_box()).as_wkt}'))"
			query = "insert into gml_objects(gml_id, ft_type, binary_object, gml_bounded_by) values('#{admin_units.shn}', 1, '#{xml}', ST_GeometryFromText('#{admin_units.env.as_wkt}'))"
			result = con.insert(query)
			result.should_not be(nil)
		rescue Exception => e
			puts "-----------------------"
			puts e
			puts "-----------------------"
		end
	end


	it "should insert transformed adminunits data into database" do
		@fconfig = YAML.load_file("./data/config/fomi.yml")
		@fomi = ActiveRecord::Base.establish_connection(@fconfig)
		@au = Transformer.new("./data/xsl/AdministrativeUnits_HU.xsl")


		config = {:host => 'localhost', :user => 'inspire', :password => 'inspire', :dbname => 'inspire'}
		con = Database.new(config)
		
		Au.all.each {|record|
			result = @au.transform_string(record.data)
			xml = result.to_s(:indent => false).gsub("\n", "")
			#query = "insert into gml_objects(gml_id, ft_type, binary_object, gml_bounded_by) values('#{record.shn}', 1, '#{result}', ST_GeometryFromText('#{record.geom.as_wkt}'))"
			query = "insert into gml_objects(gml_id, ft_type, binary_object, gml_bounded_by) values('#{record.shn}', 1, '#{xml}', ST_GeometryFromText('#{record.env.as_wkt}'))"
			con.insert(query)
		}
	end

	it "should insert transformed cadastral parcels data into database" do
		@fconfig = YAML.load_file("./data/config/fomi.yml")
		@fomi = ActiveRecord::Base.establish_connection(@fconfig)
		@cad = Transformer.new("./data/xsl/CadastralParcels_HU.xsl")


		config = {:host => 'localhost', :user => 'inspire', :password => 'inspire', :dbname => 'inspire'}
		con = Database.new(config)
		
		Cadastralm.all.each {|record|
			result = @cad.transform_string(record.xml)
			xml = result.to_s(:indent => false).gsub("\n", "")
			#query = "insert into gml_objects(gml_id, ft_type, binary_object, gml_bounded_by) values('#{record.shn}', 1, '#{result}', ST_GeometryFromText('#{record.geom.as_wkt}'))"
			query = "insert into gml_objects(gml_id, ft_type, binary_object, gml_bounded_by) values('#{record.parcel_id}', 6, '#{xml}', ST_GeometryFromText('#{record.env.as_wkt}'))"
			con.insert(query)
		}
	end
=end
end
