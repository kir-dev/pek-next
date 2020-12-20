class EvaluationPolicy < ApplicationPolicy
  def show?
    return false if off_season?

    return true if leader_of_the_group? || evaluation_helper_of_the_group?
    return true if leader_of_the_resort? || leader_in_the_resort?
    return true if pek_admin? || rvt_member?

    false
  end

  alias current? show?
  alias table? show?

  def edit?
    submit_point_request?
  end

  def update_comments?
    return true if leader_of_the_group? || evaluation_helper_of_the_group?
    return true if rvt_member?

    false
  end

  alias index? edit?
  alias update? edit?
  alias create? edit?
  alias destroy? edit?

  def edit_justification?
    return false unless submittable_request?(point_request_status)

    leader_of_the_group? || evaluation_helper_of_the_group?
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

  def submit_entry_request?
    submit_request?(entry_request_status)
  end

  def cancel_entry_request?
    cancel_request?(entry_request_status)
  end

  def update_request?(request_status)
    return false if off_season?
    return false if request_status == Evaluation::ACCEPTED

    unless request_status == Evaluation::NOT_YET_ASSESSED
      return true if leader_of_the_group? || evaluation_helper_of_the_group? || pek_admin?
    end

    if evaluation_season?
      return true if leader_of_the_resort?
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
    return false if off_season?
    return false if request_status == Evaluation::ACCEPTED
    return false unless application_season?

    if request_status == Evaluation::NOT_YET_ASSESSED
      return true if leader_of_the_group? || pek_admin?
    end

    false
  end

  private

  def leader_of_the_group?
    user.leader_of?(evaluation.group)
  end

  def evaluation_helper_of_the_group?
    user.evaluation_helper_of?(evaluation.group)
  end

  def leader_of_the_resort?
    user.leader_of?(evaluation.group.parent)
  end

  def leader_in_the_resort?
    evaluation.group.parent&.children&.any? { |group| user.leader_of?(group) }
  end

  def rvt_member?
    user.roles.rvt_member?
  end

  def point_request_status
    evaluation.point_request_status
  end

  def entry_request_status
    evaluation.entry_request_status
  end

  def evaluation
    record
  end
end
