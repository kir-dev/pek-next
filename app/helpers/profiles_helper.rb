module ProfilesHelper
  def own_memberships
    @user_presenter.memberships.sort { |a, b| a && b ? a <=> b : a ? -1 : 1 }.each do |membership|
      yield GroupMemberDecorator.decorate(GroupMember.new(membership))
    end
  end

  def years_with_points(point_history)
    point_history.map(&:semester).uniq.sort.reverse_each do |semester|
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
end
