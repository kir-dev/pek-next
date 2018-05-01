class CreatePost

  def self.call(group, membership, post_type_id)
    if post_type_id == Membership::LEADER_POST_ID
      remove_previos_leader(group)
      check_leader_reassign(membership)
    end
    Post.create(grp_member_id: membership.id, post_type_id: post_type_id)
  end

  def self.remove_previos_leader(group)
    Post.create(grp_member_id: group.leader.id,
      post_type_id: Membership::PAST_LEADER_ID)
    group.leader.post(Membership::LEADER_POST_ID).destroy
  end

  def self.check_leader_reassign(membership)
    Post.destroy_all(grp_member_id: membership.id,
      post_type_id: Membership::PAST_LEADER_ID)
  end

end
