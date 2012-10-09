require 'rubygems'
require 'active_record'
require 'spatial_adapter/postgresql'

class Au < ActiveRecord::Base
	self.table_name = "au"
end
