require 'rubygems'
require 'pg'

class Database

	def initialize(conf)
		@connection = PG.connect(conf)
	end

	def insert(sql)
		begin
			@connection.exec(sql)
		rescue Exception => e
			puts e
		end
	end

    def Database.connect(conf)
    	connection = PG.connect(conf)
    	return connection
    end
end