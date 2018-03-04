module GroupsHelper
  def active_users(group)
    @active_users = Kaminari.paginate_array(group.memberships.where(end: nil).where(archived: nil).
        sort { |a, b| a.user.lastname <=> b.user.lastname }).page(params[:active_users_page])
    @active_users.each do |membership|
      yield GroupMember.new(membership)
    end
  end

  def inactive_users(group)
    @inactive_users = Kaminari.paginate_array(group.memberships.where.not(end: nil).where(archived: nil).
        includes(:user).sort { |a, b| a.user.lastname <=> b.user.lastname }).page(params[:inactive_users_page])
    @inactive_users.each do |membership|
      yield GroupMember.new(membership)
    end
  end

  def archived_users(group)
    @archived_users = Kaminari.paginate_array(group.memberships.where.not(archived: nil).
        includes(:user).sort { |a, b| a.user.lastname <=> b.user.lastname }).page(params[:archived_users_page])
    @archived_users.each do |membership|
      yield GroupMember.new(membership)
    end
  end
end
