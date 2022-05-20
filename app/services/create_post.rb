class CreatePost
  class InvalidPostType < StandardError; end
  class PostAlreadyTaken < StandardError; end

  def self.call(group, membership, post_type_id)
    raise InvalidPostType unless group.has_post_type?(post_type_id)

    ActiveRecord::Base.transaction do
      if post_type_id == PostType::LEADER_POST_ID
        remove_leader(group)
        remove_past_leader_post(membership)
      end
      if post_type_id == PostType::FINANCIAL_OFFICER_POST_ID
        raise PostAlreadyTaken unless financial_officer_count_for(group).zero?
      end
      Post.create(membership_id: membership.id, post_type_id: post_type_id)
    end
  end

  def self.remove_leader(group)
    Post.create(membership_id: group.leader.id, post_type_id: PostType::PAST_LEADER_ID)
    group.leader.post(PostType::LEADER_POST_ID).destroy
  end

  def self.remove_past_leader_post(membership)
    Post.where(membership_id: membership.id, post_type_id: PostType::PAST_LEADER_ID).destroy_all
  end

  def self.financial_officer_count_for(group)
    Post.where('memberships.group_id': group.id,
               post_type_id: PostType::FINANCIAL_OFFICER_POST_ID)
        .joins(:membership).count
  end
end
