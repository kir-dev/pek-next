class PostType < ActiveRecord::Base
  self.table_name = "poszttipus"
  self.primary_key = :pttip_id

  alias_attribute :id, :pttip_id
  alias_attribute :name, :pttip_name
  alias_attribute :group_id, :grp_id

  belongs_to :group, foreign_key: :grp_id

  validates :name, presence: true
end
