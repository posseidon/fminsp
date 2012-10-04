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
		xml_doc = LibXML::XML::Document.string(xml_str)
		#xml_doc = LibXML::XML::Document.file(xml_doc)
  		result = @stylesheet.apply(xml_doc)
  		return result
	end

	def transform_file(xml_file)
		xml_doc = LibXML::XML::Document.file(xml_file)
  		result = @stylesheet.apply(xml_doc)
  		return result		
	end
end
