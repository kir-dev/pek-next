class DestroyPost
  def self.call(post_id)
    post = Post.find(post_id)
    return false if post.post_type_id == Membership::LEADER_POST_ID

    post.destroy
  end
end
