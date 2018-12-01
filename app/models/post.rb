class Post < ActiveRecord::Base
  self.table_name = 'poszt'
  self.primary_key = :id

  alias_attribute :membership_id, :grp_member_id
  alias_attribute :post_type_id, :pttip_id

  belongs_to :post_type, foreign_key: :pttip_id

  def leader?
    post_type_id == Membership::LEADER_POST_ID
  end
end
