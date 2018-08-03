module GroupsHelper
  def active_users(group)
    active_memberships =
      group.memberships.reject { |m| m.inactive? || m.archived? }
           .sort { |a, b| a.user.lastname <=> b.user.lastname }
    @active_users = Kaminari.paginate_array(active_memberships)
                            .page(params[:active_users_page])
                            .per(items_per_page)
    @active_users.each do |membership|
      yield GroupMemberDecorator.decorate(GroupMember.new(membership))
    end
  end

  def inactive_users(group)
    inactive_memberhips =
      group.memberships.select(&:inactive?)
           .sort { |a, b| a.user.lastname <=> b.user.lastname }
    @inactive_users = Kaminari.paginate_array(inactive_memberhips)
                              .page(params[:inactive_users_page])
                              .per(items_per_page)
    @inactive_users.each do |membership|
      yield GroupMemberDecorator.decorate(GroupMember.new(membership))
    end
  end

  def archived_users(group)
    archived_memberships =
      group.memberships.select(&:archived?)
           .sort { |a, b| a.user.lastname <=> b.user.lastname }
    @archived_users = Kaminari.paginate_array(archived_memberships)
                              .page(params[:archived_users_page])
                              .per(items_per_page)
    @archived_users.each do |membership|
      yield GroupMemberDecorator.decorate(GroupMember.new(membership))
    end
  end
end
