class EntryRequestPolicy < ApplicationPolicy
  def review?
    return false if SystemAttribute.offseason?

    pek_admin? || rvt_leader? || resort_leader?
  end

  alias update_review? review?

  private

  def rvt_leader?
    user.leader_of?(Group.rvt)
  end

  def resort_leader?
    Group.resorts.any? { |resort| user.leader_of?(resort) }
  end
end
