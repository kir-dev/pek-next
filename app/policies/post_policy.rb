class PostPolicy < ApplicationPolicy
  alias post record

  def create?
    return false unless group&.has_post_type?(post_type.id)
    return true if leader?
    return true if (evaluation_helper? || leader_assistant?) &&
      (group.own_post_types.include?(post_type) ||
        post_type.id == PostType::NEW_MEMBER_ID)

    false
  end

  alias destroy? create?

  private

  def group
    post.membership.group
  end

  def post_type
    post.post_type
  end

  def leader?
    user.leader_of?(group)
  end

  def leader_assistant?
    user.leader_assistant_of?(group)
  end

  def evaluation_helper?
    user.evaluation_helper_of?(group)
  end
end
