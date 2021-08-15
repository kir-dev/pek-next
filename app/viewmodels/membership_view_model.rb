class MembershipViewModel
  attr_reader :user, :group, :membership

  def initialize(user, group_id)
    @user = user
    @group = Group.includes([:members, { memberships: [:post_types] }]).find(group_id)
    @membership = user.membership_for(group)
    @leader = membership&.leader?
    @sssl_evaluation_helper = membership&.evaluation_helper?
    @resort_leader = @user&.roles&.resort_leader?(@group)
  end

  def leader?
    @leader
  end

  def sssl_evaluation_helper?
    @sssl_evaluation_helper
  end

  def resort_leader?
    @resort_leader
  end
end
