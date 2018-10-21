module GroupsHelper
  require 'array'

  def active_users(group)
    newbie_memberships = group.newbie_members.sort_by_name
    active_memberships = group.active_members.sort_by_name
    memberships = newbie_memberships + active_memberships

    memberships = memberships.sort_by_name unless current_user.leader_of? group

    @active_users = Kaminari.paginate_array(memberships)
                            .page(params[:active_users_page])
                            .per(items_per_page)

    @active_users.each do |membership|
      yield GroupMemberDecorator.decorate(GroupMember.new(membership))
    end
  end

  def inactive_users(group)
    inactive_memberships = group.inactive_members.sort_by_name

    @inactive_users = Kaminari.paginate_array(inactive_memberships)
                              .page(params[:inactive_users_page])
                              .per(items_per_page)

    @inactive_users.each do |membership|
      yield GroupMemberDecorator.decorate(GroupMember.new(membership))
    end
  end

  def archived_users(group)
    archived_memberships = group.archived_members.sort_by_name

    @archived_users = Kaminari.paginate_array(archived_memberships)
                              .page(params[:archived_users_page])
                              .per(items_per_page)

    @archived_users.each do |membership|
      yield GroupMemberDecorator.decorate(GroupMember.new(membership))
    end
  end
end
