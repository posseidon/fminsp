require 'rubygems'
require 'active_record'
require 'spatial_adapter/postgresql'

class Fnt < ActiveRecord::Base
	self.table_name = "fnt"

	#
	# Return coordinates of a point.
	# FNT stores geometry in POINT(X,Y).
	#
	def coordinates
		self.geometria.x.to_s + " " + self.geometria.y.to_s
	end
end
