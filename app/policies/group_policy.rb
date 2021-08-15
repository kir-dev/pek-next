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

  def create?
    user.roles.rvt_leader? || user.roles.pek_admin?
  end

  alias new? create?

  def manage_memberships?
    leader? || evaluation_helper?
  end

  alias manage_posts? manage_memberships?

  private

  alias group record

  def leader?
    user.leader_of?(group)
  end

  def evaluation_helper?
    user.evaluation_helper_of?(group)
  end
end
