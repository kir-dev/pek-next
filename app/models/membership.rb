class Membership < ActiveRecord::Base
  self.table_name = :grp_membership
  self.primary_key = :id

  alias_attribute :group_id, :grp_id
  alias_attribute :user_id, :usr_id
  alias_attribute :start, :membership_start
  alias_attribute :end, :membership_end

  belongs_to :group, foreign_key: :grp_id
  belongs_to :user, foreign_key: :usr_id
end
