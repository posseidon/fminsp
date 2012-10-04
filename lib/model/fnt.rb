require 'rubygems'
require 'active_record'
require 'spatial_adapter/postgresql'

class Fnt < ActiveRecord::Base
	self.table_name = "fnt"

	def to_xml(options = {})
	    require 'builder'
	    options[:indent] ||= 2
	    xml = options[:builder] ||= ::Builder::XmlMarkup.new(:indent => options[:indent])
	    xml.instruct! unless options[:skip_instruct]
	    xml.fnt do |fnt|
	    	fnt.id(read_attribute(:objectid), :type => "integer")
	    	fnt.name read_attribute(:nev)
	    	fnt.tipusnev  read_attribute(:tipusnev)
	    	fnt.forrasnev read_attribute(:forrasnev)
	    	unless read_attribute(:geometria).nil?
	    		geometry = read_attribute(:geometria)
	    		fnt.geometria (geometry.x.to_s + " " + geometry.y.to_s)
	    	else
	    		fnt.geometria(read_attribute(:geometria),:nil => "true")
	    	end
	    end
	end

end
