class PostType < ActiveRecord::Base
  self.table_name = "poszttipus"
  self.primary_key = :pttip_id

  alias_attribute :id, :pttip_id
  alias_attribute :name, :pttip_name
end
