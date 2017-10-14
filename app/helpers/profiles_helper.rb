module ProfilesHelper
  def own_memberships
    @user_presenter.memberships.order(end: :desc).includes(:group).each do |membership|
      yield GroupMember.new(membership)
    end
  end

  def user_detailed_point_history
    @user_presenter.pointrequests.each do |pointrequest|
      yield DetailedPointHistory.new(pointrequest)
    end
  end
end
