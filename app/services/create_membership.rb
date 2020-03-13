class CreateMembership
  def self.call(group, user)
    membership = Membership.create(group_id: group.id, user_id: user.id)
    Post.create(membership_id: membership.id, post_type_id: PostType::DEFAULT_POST_ID)
  end
end
