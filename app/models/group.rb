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
  alias_attribute :delegate_count, :grp_svie_delegate_nr
  alias_attribute :users_can_apply, :grp_users_can_apply
  alias_attribute :archived_members_visible, :grp_archived_members_visible

  has_many :memberships, foreign_key: :grp_id
  has_many :members, through: :memberships, source: :user
  has_many :post_types, foreign_key: :grp_id
  alias :own_post_types :post_types

  SVIE_ID = 369
  RVT_ID = 146
  KIRDEV_ID = 106

  def self.kirdev
    find KIRDEV_ID
  end

  def self.svie
    find SVIE_ID
  end

  def self.rvt
    find RVT_ID
  end

  def member?(user)
    user.membership_for(self)
  end

  def user_can_join?(current_user)
    users_can_apply && !member?(current_user)
  end

  def leader
    memberships.find { |membership| membership.leader? }
  end

  def post_types
    own_post_types + PostType.where(group: nil)
  end

  def current_delegated_count
    return @currently_delegated_cache if @currently_delegated_cache
    delegates = members.includes(:primary_membership).where(delegated: true)
     .select { |user| user.primary_membership.group_id == self.id && user.primary_membership.end.nil? }
    @currently_delegated_cache = delegates.length
  end

  def can_delegate_more
    current_delegated_count < delegate_count
  end

  def inactive?
    previous_eval = Evaluation.where(group_id: self.id).where(date: SystemAttribute.semester.previous.to_s).empty?
    pre_previous_eval = Evaluation.where(group_id: self.id).where(date: SystemAttribute.semester.previous.previous.to_s).empty?
    previous_eval && pre_previous_eval
  end

  def point_eligible_memberships
    memberships.includes(:user).select { |m| m.end == nil && m.archived == nil }
      .sort { |m1, m2| m1.user.full_name <=> m2.user.full_name }
  end
end
