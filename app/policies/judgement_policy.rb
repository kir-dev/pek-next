class JudgementPolicy < ApplicationPolicy
  def show?
    rvt_member?
  end

  alias index? show?

  def update?
    SystemAttribute.evaluation_season? && (rvt_leader? || leader_of_the_resort?)
  end

  def accept?
    rvt_leader?
  end

  def reject?
    rvt_leader? || leader_of_the_resort?
  end

  private

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
