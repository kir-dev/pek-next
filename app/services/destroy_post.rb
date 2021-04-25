class DestroyPost
  def self.call(post_id)
    post = Post.find(post_id)
    raise InvalidPostType unless post.membership.group.has_post_type?(post.post_type_id)
    return false if post.post_type_id == PostType::LEADER_POST_ID

    post.destroy
  end
end
