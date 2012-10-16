require 'rubygems'
require 'active_record'
require 'spatial_adapter/postgresql'

class CadastralPublic < ActiveRecord::Base
	set_table_name "mesterszallas_foldreszlet_kozt"
end
