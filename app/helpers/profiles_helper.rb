module ProfilesHelper
  def own_memberships
    @user_presenter.memberships.sort { |a, b| a && b ? a <=> b : a ? -1 : 1 }.each do |membership|
      yield GroupMember.new(membership)
    end
  end

  def years_with_points(point_history)
    point_history.map { |history| history.semester }
                 .uniq.sort.reverse.each do |semester|
      yield Semester.new(semester)
    end
  end

  def user_point_for_year(semester, user)
    user.point_history.find { |ph| ph.semester == semester }.point
  end

  def user_detailed_point_history(pointrequests, semester)
    accepted_pointrequests = pointrequests.select do |c|
      c.evaluation.accepted &&
        c.evaluation.semester == semester.to_s
    end
    accepted_pointrequests.each do |pointrequest|
      yield DetailedPointHistory.new(pointrequest)
    end
  end

  def sum_yearly_points(user, year)
    PointHistory.find_by(semester: year.to_s, user: @user_presenter.id).point
  end
end
