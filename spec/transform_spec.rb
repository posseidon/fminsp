require 'rubygems'
require 'yaml'
require 'active_record'

$LOAD_PATH << '../lib/'
require 'model/model.rb'
require 'model/transformer.rb'
require 'model/fnt.rb'
require 'model/au.rb'

=begin
describe "Transform", "#initialize" do

	it "should initialize and create a stylesheet according to xls" do
		xsl = Transformer.new("./spec/dummy.xsl")
		result = xsl.transform_file("./spec/dummy.xml")
		xsl.class.should_not be(nil)
	end

end

describe "Transform", "#transforming" do
	before do
		@fconfig = YAML.load_file("./data/config/fomi.yml")
		#@iconfig = YAML.load_file("./data/config/inspire.yml")
		@fomi = ActiveRecord::Base.establish_connection(@fconfig)
		#@inspire = ActiveRecord::Base.establish_connection(@iconfig)
		#@fnt = Transformer.new("./spec/geonames.xsl")
		@fnt = Transformer.new("./data/xsl/GeographicalNames_HU.xsl")
		@au = Transformer.new("./data/xsl/AdministrativeUnits_HU.xsl")
		#@foss_xsl = Transformer.new("./data/xsl/GeographicalNames.xsl")
	end

	it "should transform fnt record into geonames.xml" do
		begin
			fnt = Fnt.find_by_objectid(4901)
			puts fnt.xml
			result = @fnt.transform_string(fnt.xml)
			File.open("spec/output2.xml","w:UTF-8"){ |f| 
				f.write(result)
			}
		rescue Exception => e
			puts "-----------------------"
			puts e
			puts "-----------------------"
		end
		result.should_not be(nil)
	end

	it "should transform au record into auminunits.xml" do
		begin
			admin_units = Au.find_by_objectid(74)
			puts admin_units.data
			result = @au.transform_string(admin_units.data)
			File.open("spec/output3.xml","w:UTF-8"){ |f| 
				f.write(result)
			}
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

end
=end
describe "Transform", "#load" do
=begin
	it "should insert transformed geographicalnames data into database" do
		@fconfig = YAML.load_file("./data/config/fomi.yml")
		@fomi = ActiveRecord::Base.establish_connection(@fconfig)
		@fnt = Transformer.new("./data/xsl/GeographicalNames_HU.xsl")

		config = {:host => 'localhost', :user => 'inspire', :password => 'inspire', :dbname => 'inspire'}
		con = Model.new(config)
		
		Fnt.all.each {|record|
			result = @fnt.transform_string(record.xml)
			query = "insert into gml_objects(gml_id, ft_type, binary_object) values(#{record.objectid}, 8, '#{result}')"
			con.insert(query)
		}
	end
=end
	it "should insert transformed adminunits data into database" do
		@fconfig = YAML.load_file("./data/config/fomi.yml")
		@fomi = ActiveRecord::Base.establish_connection(@fconfig)
		@au = Transformer.new("./data/xsl/AdministrativeUnits_HU.xsl")


		config = {:host => 'localhost', :user => 'inspire', :password => 'inspire', :dbname => 'inspire'}
		con = Model.new(config)
		
		Au.all.each {|record|
			result = @au.transform_string(record.data)
			query = "insert into gml_objects(gml_id, ft_type, binary_object) values(#{record.objectid}, 1, '#{result}')"
			con.insert(query)
		}
	end

end
