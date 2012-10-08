require 'rubygems'
require 'pg'

class Model

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

    def Model.connect(conf)
    	connection = PG.connect(conf)
    	return connection
    end
end