class CountDelegates
  def self.call(group)
    # count = group.members.where.user.primary_membership.group: group .count
    # count = User.where primary_membership.group: group .count
    count = 2
    if count.between 5..20
      group.update delegate_count: 1
    else
      group.update delegate_count: count / 20
    end
  end
end
