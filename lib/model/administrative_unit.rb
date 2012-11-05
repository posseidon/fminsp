require 'rubygems'
require 'active_record'
require 'spatial_adapter/postgresql'

class AdministrativeUnit < ActiveRecord::Base
	set_table_name "au"
end
