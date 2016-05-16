class Poszttipus < ActiveRecord::Base
  self.table_name = "poszttipus" #Otherwise Rails would auto-pluralize
  self.primary_key = :pttip_id

  alias_attribute :id, :pttip_id
  alias_attribute :name, :pttip_name
end
