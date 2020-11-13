class EvaluationPolicy < ApplicationPolicy
  def show?
    (leader_of_the_group? || leader_of_the_resort? || pek_admin?) && !off_season?
  end

  alias current? show?
  alias table? show?

  def edit?
    ((leader_of_the_group? || pek_admin?) &&
        evaluation.changeable_point_request_status? &&
        evaluation.point_request_status != Evaluation::NOT_YET_ASSESSED)
  end

  alias index? edit?
  alias update? edit?
  alias create? edit?
  alias destroy? edit?

  def submit_point_request?
    ((leader_of_the_group? || pek_admin? ) &&
        evaluation.changeable_point_request_status? &&
        evaluation.point_request_status != Evaluation::NOT_YET_ASSESSED) ||
    (leader_of_the_resort? && evaluation_season?)
  end

  def cancel_point_request?
    (leader_of_the_group? || pek_admin?) &&
        evaluation.changeable_point_request_status? &&
        evaluation.point_request_status == Evaluation::NOT_YET_ASSESSED
  end

  def submit_entry_request?
    ((leader_of_the_group? || pek_admin?) &&
        evaluation.changeable_entry_request_status? &&
        evaluation.entry_request_status != Evaluation::NOT_YET_ASSESSED) ||
    (leader_of_the_resort? && evaluation_season?)
  end

  def cancel_entry_request?
    (leader_of_the_group? || pek_admin?) &&
        evaluation.changeable_entry_request_status? &&
        evaluation.entry_request_status == Evaluation::NOT_YET_ASSESSED
  end

  private

  def leader_of_the_group?
    user.leader_of?(evaluation.group)
  end

  def leader_of_the_resort?
    user.leader_of?(evaluation.group.parent)
  end

  def evaluation
    record
  end
end
