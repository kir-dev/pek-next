# == Schema Information
#
# Table name: memberships
#
#  id         :bigint           not null, primary key
#  archived   :date
#  end_date   :date
#  start_date :date
#  status     :string
#  group_id   :bigint
#  user_id    :bigint
#
# Indexes
#
#  membership_usr_fk_idx  (user_id)
#  unique_memberships     (group_id,user_id) UNIQUE
#
# Foreign Keys
#
#  grp_membership_grp_id_fkey  (group_id => groups.id) ON DELETE => cascade ON UPDATE => cascade
#  grp_membership_usr_id_fkey  (user_id => users.id) ON DELETE => cascade ON UPDATE => cascade
#

class Membership < ApplicationRecord
  include Notifications::MembershipNotifier

  belongs_to :group
  belongs_to :user
  has_many :posts
  has_many :post_types, through: :posts

  before_create :set_defaults

  scope :archived, -> { where.not(archived: nil) }
  scope :not_archived, -> { where(archived: nil) }
  scope :newbie, -> { not_archived.joins(:posts).where(end_date: nil, posts: {post_type: PostType::DEFAULT_POST_ID})}
  scope :not_newbie, -> { where.not(id: newbie.select(:id)) }
  scope :active, -> { not_newbie.not_archived.where(end_date: nil) }
  scope :not_active, -> { where.not(id: active.select(:id)) }

  def leader?
    has_post?(PostType::LEADER_POST_ID)
  end

  def newbie?
    has_post?(PostType::DEFAULT_POST_ID) && end_date.nil? && !archived?
  end

  def new_member?
    has_post?(PostType::NEW_MEMBER_ID) && active?
  end

  def pek_admin?
    has_post?(PostType::PEK_ADMIN_ID)
  end

  def evaluation_helper?
    has_post?(PostType::EVALUATION_HELPER_ID)
  end

  def has_post?(post_id)
    posts.any? { |post| post.post_type.id == post_id }
  end

  enum status: {
    active:   'ACTIVE',
    archived: 'ARCHIVED',
    inactive: 'INACTIVE'
  }, _prefix: :status

  def archived?
    !archived.nil?
  end

  def active?
    !newbie? && end_date.nil? && !archived?
  end

  def inactive?
    !end_date.nil? && !archived?
  end

  def post(post_type)
    posts.find_by(post_type_id: post_type)
  end

  def primary?
    active? && user.svie_member_type == SvieUser::INSIDE_MEMBER && user.primary_membership == self
  end

  def inactivate!
    self.end_date = Time.now
    self.status   = :inactive

    user.update(delegated: false) if user.delegated && user.primary_membership == self
    save
  end

  def reactivate!
    self.end_date = nil
    self.status   = :active
    save
  end

  def archive!
    self.archived = inactive? ? end_date : Time.now
    self.status   = :archived

    user.update(delegated: false) if user.delegated && user.primary_membership == self
    save
  end

  def unarchive!
    destroy_default_post
    self.archived = nil
    self.status   = :active
    save
  end

  def accept!
    destroy_default_post
    post_types << PostType.find(PostType::NEW_MEMBER_ID)
  end

  def can_request_unarchivation?
    archived? && !has_post?(PostType::DEFAULT_POST_ID)
  end

  private

  def destroy_default_post
    newbie_post = posts.find { |post| post.post_type.id == PostType::DEFAULT_POST_ID }
    newbie_post&.destroy
  end

  def set_defaults
    self.status ||= :active
  end
end
