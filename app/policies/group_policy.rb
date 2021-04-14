class GroupPolicy < ApplicationPolicy
  def index?
    true
  end

  alias all? index?
  alias show? index?

  def edit?
    leader?
  end

  alias update? edit?

  def manage_memberships?
    leader? || (group == Group.sssl && evaluation_helper?)
  end

  private

  alias group record

  def leader?
    user.leader_of?(group)
  end

  def evaluation_helper?
    user.evaluation_helper_of?(group)
  end
end
