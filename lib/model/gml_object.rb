require 'rubygems'
require 'active_record'
require 'spatial_adapter/postgresql'

class GmlObject < ActiveRecord::Base
	self.table_name = "gml_objects"

	def connection
		
	end

end
