module ProfilesHelper
  def own_memberships
    @user_presenter.memberships.order(end: :desc).includes(:group).each do |membership|
      yield GroupMember.new(membership)
    end
  end
end
