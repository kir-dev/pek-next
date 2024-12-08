class EntryRequestPolicy < ApplicationPolicy
  def review?
    pek_admin? || rvt_leader? || resort_leader?
  end

  private

  def rvt_leader?
    user.leader_of?(Group.rvt)
  end
  def resort_leader?
    Group.resorts.any? { |resort| user.leader_of?(resort) }
  end
end
