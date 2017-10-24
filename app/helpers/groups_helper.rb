module GroupsHelper
  def active_users(group)
    @active_users = group.memberships.where(end: nil).page(params[:active_users_page]).includes(:user)
    @active_users.each do |membership|
      yield GroupMember.new(membership)
    end
  end

  def inactive_users(group)
    @inactive_users = group.memberships.where.not(end: nil).page(params[:inactive_users_page]).includes(:user)
    @inactive_users.each do |membership|
      yield GroupMember.new(membership)
    end
  end
end
