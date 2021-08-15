module ProfilesHelper
  def own_memberships
    @user_presenter.memberships.sort { |a, b| a && b ? a <=> b : a ? -1 : 1 }.each do |membership|
      yield membership.decorate
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
end
