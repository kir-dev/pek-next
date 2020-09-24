class EvaluationPolicy < ApplicationPolicy
  def show?
    (leader_of_the_group? || leader_of_the_resort?) && !off_season?
  end

  alias current? show?
  alias table? show?

  def edit?
    leader_of_the_group? && application_season?
  end

  alias update? edit?

  def submit_point_request?
    leader_of_the_group? && evaluation.changeable_point_request_status?
  end

  alias cancel_point_request? submit_point_request?

  def submit_entry_request?
    leader_of_the_group? && evaluation.changeable_entry_request_status?
  end

  alias cancel_entry_request? submit_entry_request?

  private

  def leader_of_the_group?
    user.leader_of?(evaluation.group)
  end

  def leader_of_the_resort?
    user.leader_of?(evaluation.group.parent)
  end

  def off_season?
    SystemAttribute.offseason?
  end

  def application_season?
    SystemAttribute.application_season?
  end

  def evaluation
    record
  end
end
