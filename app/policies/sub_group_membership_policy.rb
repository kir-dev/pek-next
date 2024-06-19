class SubGroupMembershipPolicy < ApplicationPolicy
  alias sub_group_membership record


  def destroy?
    leader_of_the_group? || sub_group_admin?
  end

  private

  def sub_group_admin?
    current_user_sub_group_membership = SubGroupMembership.find_by(sub_group: sub_group, membership: membership)
    current_user_sub_group_membership&.admin?
  end

  def leader_of_the_group?
    membership.present? && membership.has_post?(PostType::LEADER_POST_ID)
  end

  def membership
    user.membership_for(sub_group.group)
  end

  def sub_group
    sub_group_membership.sub_group
  end
end
