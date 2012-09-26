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
		puts fnt.coordinates
		fnt.should_not be(nil)		
	end
end

