# frozen_string_literal: true

class Membership::CreateService
  attr_reader :group, :user

  class AlreadyMember < StandardError; end
  class GroupNotReceivingNewMembers < StandardError; end

  def initialize(group, user)
    @group = group
    @user  = user
  end

  def self.call(group, user)
    new(group, user).perform
  end

  def perform
    raise GroupNotReceivingNewMembers unless group.users_can_apply
    raise AlreadyMember if membership.present? && !membership.archived?

    if membership.present?
      unarchive_membership
    else
      create_membership
    end
    membership.notify(:users, key: 'membership.create', notifier: user)
  end

  private

  def create_membership
    ActiveRecord::Base.transaction do
      @membership = Membership.create!(group: group, user: user)
      create_default_post
    end
  end

  def unarchive_membership
    default_post = Post.find_by(membership: membership, post_type_id: PostType::DEFAULT_POST_ID)

    ActiveRecord::Base.transaction do
      membership.update!(archived: nil)
      create_default_post unless default_post.present?
    end
  end

  def create_default_post
    Post.create(membership: membership, post_type_id: PostType::DEFAULT_POST_ID)
  end

  def membership
    @membership ||= Membership.find_by(group: group, user: user)
  end
end
