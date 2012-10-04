require 'rubygems'
require 'yaml'
require 'active_record'

$LOAD_PATH << '../lib/'
require 'model/transformer.rb'
require 'model/fnt.rb'

describe "Transform", "#initialize" do

	it "should initialize and create a stylesheet according to xls" do
		xsl = Transformer.new("./spec/dummy.xsl")
		result = xsl.transform("./spec/dummy.xml")
		xsl.class.should_not be(nil)
	end

end

describe "Transform", "#transforming" do
	before do
		@config = YAML.load_file("./data/config/fomi.yml")
		@db = ActiveRecord::Base.establish_connection(@config)
		@xsl = Transformer.new("./spec/geonames.xsl")
	end

	it "should transform fnt record into geonames.xml" do
		fnt = Fnt.find_by_objectid(4901)
		result = @xsl.transform("./spec/output.xml")
		puts result
		#result = @xsl.transform(fnt.to_xml)
=begin
		File.open("spec/output.xml","w:UTF-8"){ |f| 
			f.write(fnt.to_xml)
		}
=end
		result.should_not be(nil)
	end

end
