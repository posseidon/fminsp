require 'rubygems'
require 'active_record'
require 'spatial_adapter/postgresql'

class Fnt < ActiveRecord::Base
	self.table_name = "fnt"

	def to_xml(options = {})
	    require 'builder'
	    xml = Builder::XmlMarkup.new
	    xml.instruct!(:xml, :encoding => "UTF-8")
	    xml.fnt do |fnt|
	    	fnt.id(read_attribute(:objectid), :type => "integer")
	    	fnt.nev { |x| x << self.nev }
	    	fnt.tipusnev { |x| x << self.tipusnev }
	    	fnt.typename { |x| x << self.typename }
	    	fnt.forrasnev { |x| x << self.forrasnev }
=begin
	    	unless read_attribute(:geometria).nil?
	    		geometry = read_attribute(:geometria)
	    		fnt.geometria (geometry.x.to_s + " " + geometry.y.to_s)
	    	else
	    		fnt.geometria(read_attribute(:geometria),:nil => "true")
	    	end
=end
	    end
	end

end
