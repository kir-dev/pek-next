module SubGroupPolicyHelper

  private

  def admin_for_any_sub_group?
    SubGroupMembership.joins(:sub_group, :membership).where('sub_groups.group_id': sub_group.group.id,
                                                            'memberships.user_id': user.id,
                                                            admin: true).present?
  end
end
