class MembershipViewModel
  attr_reader :user, :group

  def initialize(user, group_id)
    @user = user
    @group = Group.find(group_id)
  end

  def leader?
    membership = user.membership_for(group)
    return membership.leader? if membership
  end
end
