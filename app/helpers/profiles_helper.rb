module ProfilesHelper
  def own_memberships
    @user_presenter.memberships.order(end: :desc)
                   .includes(:group).each do |membership|
      yield GroupMember.new(membership)
    end
  end

  def years_with_points(pointrequests)
    pointrequests.map { |request| request.evaluation.semester }
                 .uniq.sort.reverse.each do |semester|
      yield Semester.new(semester)
    end
  end

  def user_point_for_year(semester, user)
    PointHistory.find_by(semester: semester, user: user).point
  end

  def user_detailed_point_history(pointrequests, semester)
    accepted_pointrequests = pointrequests.select do |c|
      c.evaluation.accepted &&
        c.evaluation.date == semester.to_s
    end

    accepted_pointrequests.each do |pointrequest|
      yield DetailedPointHistory.new(pointrequest)
    end
  end

  def sum_yearly_points(user, year)
    PointHistory.find_by(semester: year.to_s, user: @user_presenter.id).point
  end
end
