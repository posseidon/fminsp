require 'rubygems'
require 'yaml'
require 'active_record'

$LOAD_PATH << '../lib/'
require 'model/model.rb'
require 'model/transformer.rb'
require 'model/fnt.rb'

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
		#@xsl = Transformer.new("./spec/geonames.xsl")
		@xsl = Transformer.new("./data/xsl/GeographicalNames_HU.xsl")
		#@foss_xsl = Transformer.new("./data/xsl/GeographicalNames.xsl")
	end

	it "should transform fnt record into geonames.xml" do
		begin
			fnt = Fnt.find_by_objectid(4901)
			puts fnt.xml
			result = @xsl.transform_string(fnt.xml)
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
=begin
	it "should validate resulted gml by xsd" do
		result = @xsl.validate_file("data/xsd/GeographicalNames.xsd","spec/output2.xml")
		puts result
		result.should_not be(nil)		
	end
=end
end
=begin
describe "Transform", "#load" do
	it "should insert transformed data into database" do
		@fconfig = YAML.load_file("./data/config/fomi.yml")
		@fomi = ActiveRecord::Base.establish_connection(@fconfig)
		@xsl = Transformer.new("./data/xsl/gnames.xsl")

		config = {:host => 'localhost', :user => 'inspire', :password => 'inspire', :dbname => 'inspire'}
		con = Model.new(config)
		
		Fnt.all.each {|record|
			result = @xsl.transform_string(record.xml)
			query = "insert into gml_objects(gml_id, ft_type, binary_object) values(#{record.objectid}, 8, '#{result}')"
			con.insert(query)
		}
	end
end
=end