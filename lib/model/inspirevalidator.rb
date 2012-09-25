require 'rubygems'
require_relative 'model'

class InspireValidator
    include Model

	def initialize(database)
        Model.connect(database)
	end

    #private
    def inspire_tables?
        resultset = ActiveRecord::Base.connection.execute("select schemaname, tablename, tableowner from pg_tables where tablename in ('feature_types','gml_objects')")
        resultset.ntuples() == 2 ? true : false
    end

    def feature_types?(src_schemas)
        schemas = Array.new
        ActiveRecord::Base.connection.execute("select qname from feature_types").each{|r|
            schemas.push(r['qname'].strip!)
        }
        (schemas - src_schemas).empty?
    end
end	

