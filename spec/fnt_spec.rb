require 'rubygems'
require 'active_record'

$LOAD_PATH << '../lib/'
require 'model/model.rb'
require 'model/fnt.rb'

describe "Fnt", "#initialize" do
	it "should connect and retrieve data" do
		Model.connect(:fomi)
		fnt = Fnt.find_by_gid(5936)
		fnt.should_not be(nil)
	end

	it "should retrieve gemetry data" do
		Model.connect(:fomi)
		fnt = Fnt.find_by_gid(5936)
		#puts fnt.coordinates
		fnt.should_not be(nil)		
	end
end

describe "Fnt", "#serialization" do
	it "should create new dummy data and serialize non-geometry data" do
		Model.connect(:fomi)
		fnt = Fnt.new(:gid => -1, :tipusnev => 'alma', :forrasnev => 'korte', :nev => 'fruits')
		content = ''
		File.open("spec/simple_fnt.xml", "r"){ |f|
			content = f.read
		}
		(fnt.to_xml).should eq(content)
	end

	it "should retrieve data and serialize record into xml" do
		Model.connect(:fomi)
		fnt = Fnt.find_by_gid(5936)
		File.open("spec/output.xml","w:UTF-8"){ |f| 
			f.write(fnt.to_xml)
		}
		fnt.should_not be(nil)
	end
end


