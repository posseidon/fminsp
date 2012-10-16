require 'rubygems'
require 'active_record'
require_relative 'database'

class InspireValidator

	def initialize(connnection_settings = {:adapter => 'postgresql', :host => 'localhost', :database => 'inspire', :username => 'inspire', :password => 'inspire'})
        @db = ActiveRecord::Base.establish_connection(connnection_settings)
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

