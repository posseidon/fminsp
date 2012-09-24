require 'rubygems'
require 'sequel'

module Model
    class DbHandler
    	def initialize(args)
            @DB = Sequel.connect("postgres://inspire:inspire@localhost/inspire")    		
    	end

        #private
        def inspire_tables?
            dataset = @DB["select schemaname, tablename, tableowner from pg_tables where tablename in ('feature_types','gml_objects')"]
            dataset.count == 3 ? false : true
        end

        def feature_types?(src_schemas)
            schemas = Array.new
            (@DB["select qname from feature_types"]).each{ |r| 
                schemas.push(r.values[0].strip!)
            }
            (schemas - src_schemas).empty?
        end
    end	
end
