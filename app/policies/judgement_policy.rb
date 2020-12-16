class JudgementPolicy < ApplicationPolicy
  def show?
    !SystemAttribute.offseason? && rvt_member?
  end

  alias index? show?

  def update?
    SystemAttribute.evaluation_season? && (rvt_leader? || leader_of_the_resort?)
  end

  def update_point_request_status?
    update_request_status?(evaluation.point_request_status)
  end

  def update_entry_request_status?
    update_request_status?(evaluation.entry_request_status)
  end

  def accept?
    SystemAttribute.evaluation_season? && rvt_leader?
  end

  private

  def update_request_status?(request_status)
    return false unless update?

    if request_status == Evaluation::ACCEPTED
      return false unless rvt_leader?
    end

    true
  end

  def leader_of_the_resort?
    user.roles.resort_leader?(evaluation.group)
  end

  def rvt_leader?
    user.roles.rvt_leader?
  end

  def rvt_member?
    user.roles.rvt_member?
  end

  def evaluation
    record
  end
end
