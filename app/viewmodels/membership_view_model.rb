class MembershipViewModel
  attr_reader :user, :group, :membership

  def initialize(user, group_id)
    @user = user
    @group = Group.includes([:members, { memberships: [:post_types] }]).find(group_id)
    @membership = user.membership_for(group)
  end

  def leader?
    return membership.leader? if membership
  end

  def sssl_evaluation_helper?
    return membership.group == Group.sssl && membership.evaluation_helper? if membership
  end

  def resort_leader?
    @user.roles.resort_leader?(@group)
  end
end
