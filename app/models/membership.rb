class Membership < ActiveRecord::Base
  self.table_name = :grp_membership
  self.primary_key = :id

  alias_attribute :group_id, :grp_id
  alias_attribute :user_id, :usr_id
  alias_attribute :start, :membership_start
  alias_attribute :end, :membership_end

  belongs_to :group, foreign_key: :grp_id
  belongs_to :user, foreign_key: :usr_id
  has_many :posts, foreign_key: :grp_member_id
  has_many :post_types, through: :posts

  LEADER_POST_ID = 3
  PAST_LEADER_ID = 4
  DEFAULT_POST_ID = 6
  PEK_ADMIN_ID = 66

  def leader?
    has_post?(LEADER_POST_ID)
  end

  def newbie?
    has_post?(DEFAULT_POST_ID)
  end

  def pek_admin?
    has_post?(PEK_ADMIN_ID)
  end

  def has_post?(post_id)
    posts.any? { |post| post.post_type.id == post_id }
  end

  def archived?
    !self.archived.nil?
  end

  def active?
    !self.newbie? && self.end.nil? && !self.archived?
  end

  def post(post_type)
    posts.find_by(post_type_id: post_type)
  end

  def inactivate!
    self.end = Time.now

    if self.user.delegated && self.user.primary_membership == self
      self.user.update(delegated: false)
    end

    save
  end

  def reactivate!
    self.end = nil
    save
  end

  def archive!
    self.archived = Time.now

    if self.user.delegated && self.user.primary_membership == self
      self.user.update(delegated: false)
    end

    save
  end

  def unarchive!
    self.archived = nil
    save
  end

  def accept!
    newbie_post = posts.find { |post| post.post_type.id == DEFAULT_POST_ID }
    newbie_post.destroy
  end

end
