require 'xslt'

#
# TODO: Copy dlls related to libxml and libxslt gems to ruby_home/bin
#


class Transformer
	def initialize(xsl_file)
		@stylesheet_doc = LibXML::XML::Document.file(xsl_file)
		@stylesheet = XSLT::Stylesheet.new(@stylesheet_doc)
	end

	def transform_string(xml_str)
		puts "*********************"
		xml_doc = LibXML::XML::Document.string(xml_str)
  		result = @stylesheet.apply(xml_doc)
  		puts "*********************"
  		return result
	end

	def transform_file(xml_file)
		xml_doc = LibXML::XML::Document.file(xml_file)
  		result = @stylesheet.apply(xml_doc)
  		return result		
	end

	def validate_str(xsd_file, xml_str)
		xml_doc = LibXML::XML::Document.string(xml_str)
		xml_schema = LibXML::XML::Schema.new(xsd_file)
		result = xml_doc.validate_schema(xml_schema) do |message,flag|
			puts message
		end
	end

	def validate_file(xsd_file, xml_file)
		xml_doc = LibXML::XML::Document.file(xml_file)
		xml_schema = LibXML::XML::Schema.new(xsd_file)
		result = xml_doc.validate_schema(xml_schema) do |message,flag|
			puts message
		end		
	end
end
