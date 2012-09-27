require 'rubygems'
require 'pg'

module Model
    def Model.connect(conf)
    	connection = PG.connect(conf)
    	return connection
    end
end