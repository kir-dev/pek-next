module GroupsHelper
  def active_users
    @viewmodel.group.memberships.where(end: nil).includes(:user).each do |membership|
      yield ActiveUser.new(membership)
    end
  end
end
