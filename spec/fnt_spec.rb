require 'rubygems'
require 'active_record'
require 'yaml'

$LOAD_PATH << '../lib/'
require 'model/model.rb'
require 'model/fnt.rb'

describe "Fnt", "#initialize" do
	before do
		@config = YAML.load_file("./data/config/fomi.yml")
		@db = ActiveRecord::Base.establish_connection(@config)
	end

	it "should connect and retrieve data" do
		fnt = Fnt.find_by_gid(5936)
		fnt.should_not be(nil)
	end

	it "should retrieve gemetry data" do
		fnt = Fnt.find_by_gid(5936)
		fnt.should_not be(nil)		
	end
end

describe "Fnt", "#serialization" do
	before do
		@config = YAML.load_file("./data/config/fomi.yml")
		@db = ActiveRecord::Base.establish_connection(@config)
	end

	it "should create new dummy data and serialize non-geometry data" do
		fnt = Fnt.new(:gid => -1, :tipusnev => 'alma', :forrasnev => 'korte', :nev => 'fruits')
		content = ''
		File.open("spec/simple_fnt.xml", "r"){ |f|
			content = f.read
		}
		(fnt.to_xml).should eq(content)
	end

	it "should retrieve data and serialize record into xml" do
		fnt = Fnt.find_by_gid(5936)
		File.open("spec/output.xml","w:UTF-8"){ |f| 
			f.write(fnt.to_xml)
		}
		fnt.should_not be(nil)
	end
end


