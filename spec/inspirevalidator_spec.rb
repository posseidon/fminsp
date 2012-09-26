$LOAD_PATH << '../lib/'
require 'model/model.rb'
require 'model/inspirevalidator.rb'
require 'model/fnt.rb'

describe Model, "#configuration" do
	it "should parse database.yml and connect accordingly" do
		#conn = Model.connect({:host => 'localhost', :dbname => 'fomi', :username => 'fomi', :password => 'fomi'})
		#conn.connected?.should_not be(nil)
	end
end

describe InspireValidator, "#connect" do
    it "should returns connection status active" do
        db = InspireValidator.new({:adapter => 'postgresql', :host => 'localhost', :database => 'inspire', :username => 'inspire', :password => 'inspire'})
        db.should_not be(nil)
    end
end

describe InspireValidator, "#inspire_tables" do
	before do
		@db = InspireValidator.new({:adapter => 'postgresql', :host => 'localhost', :database => 'inspire', :username => 'inspire', :password => 'inspire'})
	end

	it "should returns inspire tables" do
		@db.inspire_tables?.should be(true)
	end

	it "should have all feature types listed in inpire_schemas" do
		src_schema = Array.new
		File.open('spec/inspire_schemas.txt', 'r').each_line{|line|
			src_schema.push((line.to_s).strip!)
		}
		@db.feature_types?(src_schema).should eq(true)
	end
end
