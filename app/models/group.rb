# == Schema Information
#
# Table name: groups
#
#  id                       :bigint           not null, primary key
#  archived_members_visible :boolean
#  delegate_count           :integer
#  description              :text
#  founded                  :integer
#  grp_type                 :string(20)
#  head                     :string(48)
#  issvie                   :boolean          default(FALSE), not null
#  maillist                 :string(64)
#  name                     :text             not null
#  state                    :string           default("akt")
#  type                     :string
#  users_can_apply          :boolean          default(TRUE), not null
#  webpage                  :string(64)
#  parent_id                :bigint
#
# Indexes
#
#  groups_grp_id_idx    (id) UNIQUE
#  idx_groups_grp_name  (name)
#  idx_groups_grp_type  (grp_type)
#
# Foreign Keys
#
#  $1  (parent_id => groups.id) ON DELETE => nullify ON UPDATE => cascade
#

class Group < ApplicationRecord
  self.inheritance_column = nil

  alias_attribute :parent, :group

  has_many :memberships
  has_many :members, through: :memberships, source: :user
  has_many :post_types
  has_many :evaluations
  has_many :point_requests, through: :evaluations
  has_many :entry_requests, through: :evaluations
  has_many :children, class_name: 'Group', foreign_key: :parent_id
  belongs_to :group, foreign_key: :parent_id, optional: true
  alias own_post_types post_types

  scope :resorts, -> { where(parent_id: Group::RVT_ID) }

  SVIE_ID = 369
  RVT_ID = 146
  KIRDEV_ID = 106
  KB_ID = 1
  SIMONYI_ID = 16
  SSSL_ID = 18

  enum type: {
    group: 'group',
    resort: 'resort',
    team: 'team'
  }, _prefix: :type

  def self.kirdev
    find KIRDEV_ID
  end

  def self.svie
    find SVIE_ID
  end

  def self.rvt
    find RVT_ID
  end

  def self.sssl
    find SSSL_ID
  end

  def inactive_members
    memberships.select(&:inactive?)
  end

  def active_members
    memberships.select(&:active?)
  end

  def archived_members
    memberships.select(&:archived?)
  end

  def newbie_members
    memberships.select(&:newbie?)
  end

  def member?(user)
    user.membership_for(self)
  end

  def user_can_join?(current_user)
    users_can_apply && !member?(current_user)
  end

  def leader
    memberships.includes(posts: [:post_type]).find(&:leader?)
  end

  def post_types
    own_post_types + PostType.where(group: nil)
  end

  def current_delegated_count
    return @currently_delegated_cache if @currently_delegated_cache

    delegates =
      members.includes(:primary_membership).where(delegated: true).select do |user|
        user.primary_membership.group_id == id && user.primary_membership.end_date.nil?
      end
    @currently_delegated_cache = delegates.length
  end

  def can_delegate_more
    current_delegated_count < delegate_count
  end

  def inactive?
    return false if founded_less_than_a_year_ago?

    !active_in_last_two_semesters?
  end
  include ApplicationHelper
  def point_eligible_memberships
    memberships.active.includes(:user)
               .sort { |m1, m2| hu_compare(m1.user.full_name, m2.user.full_name) }
  end

  def accepted_evaluations_by_date
    # According to this measurement, this is the fastest way to reverse sort
    # https://stackoverflow.com/questions/2642182/sorting-an-array-in-descending-order-in-ruby#2651028
    evaluations.select(&:accepted)
               .sort_by(&:date)
               .reverse!
  end

  def has_post_type?(post_type_id)
    post_types.pluck(:id).include?(post_type_id)
  end

  def resort?
    Group.resorts.include?(self)
  end

  def primary_memberships
    primary_membership_ids = User.joins(:primary_membership).where('memberships.group_id': id)
                                 .where.not(svie_member_type: SvieUser::NOT_MEMBER)
                                 .pluck(:svie_primary_membership)
    Membership.where(id: primary_membership_ids).active
  end

  private

  def founded_less_than_a_year_ago?
    founded.present? && Time.now.year - 1 <= founded
  end

  def active_in_last_two_semesters?
    previous_semester = SystemAttribute.semester.previous
    return true if Evaluation.exists?(group_id: id, date: previous_semester.to_s)

    pre_previous_semester = previous_semester.previous
    Evaluation.exists?(group_id: id, date: pre_previous_semester.to_s)
  end
end
