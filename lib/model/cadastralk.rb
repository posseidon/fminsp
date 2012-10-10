require 'rubygems'
require 'active_record'
require 'spatial_adapter/postgresql'

class Cadastralk < ActiveRecord::Base
	set_table_name "mesterszallas_foldreszlet_kozt"
end
