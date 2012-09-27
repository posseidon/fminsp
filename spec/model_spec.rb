require 'rubygems'

$LOAD_PATH << '../lib/'
require 'model/model.rb'


describe "Model", "#Postgresql executer" do
	it "should connect to PostgreSQL database" do
		config = {:host => 'localhost', :user => 'postgres', :password => 'password'}
		conn = Model.connect(config)
		conn.should_not be(nil)
	end

	it "should connect and execute an SQL command" do
		config = {:host => 'localhost', :user => 'postgres', :password => 'password'}
		conn = Model.connect(config)
		result = conn.exec("select tablename from pg_tables limit 1")
		result.res_status(result.result_status()).should eq("PGRES_TUPLES_OK")
	end

end

