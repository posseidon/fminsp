$LOAD_PATH << '../lib/'
require 'model/dbhandler.rb'

describe Model::DbHandler, "#connect" do
    it "should returns connection status active" do
        db = Model::DbHandler.new('alma')
        db.should_not be(nil)
    end
end

describe Model::DbHandler, "#inspire_tables" do
	before do
		@db = Model::DbHandler.new('alma')
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
