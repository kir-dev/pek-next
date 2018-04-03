class Group < ActiveRecord::Base
  self.primary_key = :grp_id

  alias_attribute :id, :grp_id
  alias_attribute :name, :grp_name
  alias_attribute :type, :grp_type
  alias_attribute :parent, :grp_parent
  alias_attribute :state, :grp_state
  alias_attribute :description, :grp_description
  alias_attribute :webpage, :grp_webpage
  alias_attribute :maillist, :grp_maillist
  alias_attribute :head, :grp_head
  alias_attribute :founded, :grp_founded
  alias_attribute :issvie, :grp_issvie
  alias_attribute :svie_delegate_nr, :grp_svie_delegate_nr
  alias_attribute :users_can_apply, :grp_users_can_apply

  has_many :memberships, foreign_key: :grp_id
  has_many :members, through: :memberships, source: :user

  def member?(user)
    user.membership_for(self)
  end

  def user_can_join?(current_user)
    users_can_apply && !member?(current_user)
  end

  def leader
    memberships.find { |membership| membership.is_leader }
  end
end
