class MembershipPolicy < ApplicationPolicy
  alias membership record

  def own_membership?
    membership.user == user
  end

  def group_membership_manager?
    GroupPolicy.new(user, membership.group).manage_memberships?
  end

  alias archive? group_membership_manager?
  alias unarchive? group_membership_manager?
  alias inactivate? group_membership_manager?
  alias reactivate? group_membership_manager?
  alias accept? group_membership_manager?
  def withdraw?
    return false unless membership.newbie?

    own_membership? || group_membership_manager?
  end
end
