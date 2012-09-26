require 'rubygems'
require 'yaml'
require 'active_record'

module Model
    def Model.connect(configuration)
        #config = YAML.load_file('lib/model/database.yml')
		#ActiveRecord::Base.establish_connection(config[configuration.to_sym])
    end
end