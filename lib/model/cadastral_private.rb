require 'rubygems'
require 'active_record'
require 'spatial_adapter/postgresql'

class CadastralPrivate < ActiveRecord::Base
	set_table_name "mesterszallas_foldreszlet_magan"
end
