module ProfilesHelper
  def own_memberships
    @user_presenter.memberships.order(end: :desc).includes(:group).each do |membership|
      yield GroupMember.new(membership)
    end
  end

  def years_with_points(pointrequests)
    pointrequests.map{|request| request.evaluation.semester}.uniq.sort.reverse.each do |semester|
      yield Semester.new(semester)
    end
  end

  def user_detailed_point_history(pointrequests, semester)
    pointrequests.select{|c| c.evaluation.accepted &&
      c.evaluation.date == semester.to_s}.each do |pointrequest|
      yield DetailedPointHistory.new(pointrequest)
    end
  end
end
