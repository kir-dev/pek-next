# == Schema Information
#
# Table name: memberships
#
#  id         :bigint           not null, primary key
#  group_id   :bigint
#  user_id    :bigint
#  start_date :date
#  end_date   :date
#  archived   :date
#

class Membership < ApplicationRecord
  belongs_to :group
  belongs_to :user
  has_many :posts
  has_many :post_types, through: :posts

  FINANCIAL_OFFICER_POST_ID = 1
  LEADER_POST_ID = 3
  PAST_LEADER_ID = 4
  DEFAULT_POST_ID = 6
  PEK_ADMIN_ID = 66
  NEW_MEMBER_ID = 104

  def leader?
    has_post?(LEADER_POST_ID)
  end

  def newbie?
    has_post?(DEFAULT_POST_ID) && end_date.nil? && !archived?
  end

  def new_member?
    has_post?(NEW_MEMBER_ID) && active?
  end

  def pek_admin?
    has_post?(PEK_ADMIN_ID)
  end

  def has_post?(post_id)
    posts.any? { |post| post.post_type.id == post_id }
  end

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

    user.update(delegated: false) if user.delegated && user.primary_membership == self
    save
  end

  def reactivate!
    self.end_date = nil
    save
  end

  def archive!
    self.archived = Time.now

    user.update(delegated: false) if user.delegated && user.primary_membership == self
    save
  end

  def unarchive!
    self.archived = nil
    save
  end

  def accept!
    newbie_post = posts.find { |post| post.post_type.id == DEFAULT_POST_ID }
    newbie_post.destroy
    post_types << PostType.find(NEW_MEMBER_ID)
  end
end
