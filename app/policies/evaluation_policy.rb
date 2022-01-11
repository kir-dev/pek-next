class EvaluationPolicy < ApplicationPolicy
  def show?
    return false if off_season?

    return true if leader_of_the_group? || evaluation_helper_of_the_group?
    return true if leader_of_the_resort? || leader_in_the_resort?
    return true if evaluation_helper_in_the_resort? || evaluation_helper_at_resort?
    return true if pek_admin? || rvt_member?

    false
  end

  alias current? show?
  alias table? show?

  def edit?
    submit_point_request?
  end

  alias index? edit?
  alias update? edit?
  alias create? edit?
  alias destroy? edit?

  def update_comments?
    return true if leader_of_the_group? || evaluation_helper_of_the_group?
    return true if leader_in_the_resort? || evaluation_helper_in_the_resort?
    return true if rvt_member?

    false
  end

  def update_point_request?
    update_request?(point_request_status)
  end

  def submit_point_request?
    submit_request?(point_request_status)
  end

  def cancel_point_request?
    cancel_request?(point_request_status)
  end

  def update_entry_request?
    update_request?(entry_request_status)
  end
  alias edit_justification? update_entry_request?

  def submit_entry_request?
    submit_request?(entry_request_status)
  end

  def cancel_entry_request?
    cancel_request?(entry_request_status)
  end

  private

  def update_request?(request_status)
    return false if off_season?
    return false if request_status == Evaluation::ACCEPTED

    unless request_status == Evaluation::NOT_YET_ASSESSED
      return true if leader_of_the_group? || evaluation_helper_of_the_group? || pek_admin?
    end

    if evaluation_season?
      return true if leader_of_the_resort? || rvt_leader?
    end

    false
  end

  def submit_request?(request_status)
    return false unless submittable_request?(request_status)

    leader_of_the_group? || pek_admin?
  end

  def submittable_request?(request_status)
    return false if off_season?
    return false if request_status == Evaluation::ACCEPTED
    return false if request_status == Evaluation::NOT_YET_ASSESSED

    true
  end

  def cancel_request?(request_status)
    return false unless application_season?
    return false unless request_status == Evaluation::NOT_YET_ASSESSED

    leader_of_the_group? || pek_admin?
  end

  def leader_of_the_group?
    cache { user.leader_of?(evaluation.group) }
  end

  def evaluation_helper_of_the_group?
    cache { user.evaluation_helper_of?(evaluation.group) }
  end

  def leader_of_the_resort?
    return false unless group_is_a_resort_member?

    cache { user.leader_of?(evaluation.group.parent) }
  end

  def leader_in_the_resort?
    return false unless group_is_a_resort_member?

    cache { evaluation.group.parent&.children&.any? { |group| user.leader_of?(group) } }
  end

  def evaluation_helper_in_the_resort?
    return false unless group_is_a_resort_member?

    resort_groups = evaluation.group.parent&.children
    resort_memberships = Membership.where(user: user, group: resort_groups)
    evaluation_helper_posts = Post.where(membership: resort_memberships, post_type_id: PostType::EVALUATION_HELPER_ID)
    !evaluation_helper_posts.empty?
  end

  def group_is_a_resort_member?
    cache { Group.resorts.include?(evaluation.group.parent)}
  end

  def group_is_a_resort?
    Group.resorts.include?(evaluation.group.parent)
  end

  def evaluation_helper_at_resort?
    return false unless group_is_a_resort?

    membership = Membership.find_by(group: evaluation.group.parent, user: user)
    return false unless membership

    membership.has_post?(PostType::EVALUATION_HELPER_ID)
  end

  def rvt_member?
    cache { user.roles.rvt_member? }
  end

  def rvt_leader?
    cache { user.roles.rvt_leader? }
  end

  def point_request_status
    cache { evaluation.point_request_status }
  end

  def entry_request_status
    cache { evaluation.entry_request_status }
  end

  def evaluation
    record
  end
end
