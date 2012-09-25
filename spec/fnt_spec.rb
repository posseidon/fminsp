require 'rubygems'
require 'active_record'

$LOAD_PATH << '../lib/'
require 'model/model.rb'
require 'model/fnt.rb'

describe "Fnt", "#initialize" do
	it "should connect and retrieve data" do
		Model.connect(:fomi)
		puts Fnt.count
	end
end

