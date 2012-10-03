require 'rubygems'

$LOAD_PATH << '../lib/'
require 'model/transform.rb'

describe "Transform", "#initialize" do

	it "should initialize and create a stylesheet according to xls" do
		xsl = Transform.new
		result = xsl.setup("./spec/dummy.xsl", "./spec/dummy.xml")
		xsl.class.should_not be(nil)
	end

end
