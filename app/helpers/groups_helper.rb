module GroupsHelper
  def active_users(group)
    group.memberships.where(end: nil).includes(:user).each do |membership|
      yield GroupMember.new(membership)
    end
  end

  def inactive_users(group)
    group.memberships.where.not(end: nil).includes(:user).each do |membership|
      yield GroupMember.new(membership)
    end
  end
end
