class CreatePost
  def self.call(group, membership, post_type_id)
    if post_type_id == PostType::LEADER_POST_ID
      remove_leader(group)
      remove_past_leader_post(membership)
    end
    Post.create(membership_id: membership.id, post_type_id: post_type_id)
  end

  def self.remove_leader(group)
    Post.create(membership_id: group.leader.id, post_type_id: PostType::PAST_LEADER_ID)
    group.leader.post(PostType::LEADER_POST_ID).destroy
  end

  def self.remove_past_leader_post(membership)
    Post.where(membership_id: membership.id, post_type_id: PostType::PAST_LEADER_ID).destroy_all
  end
end
