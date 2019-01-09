module JudgementsHelper
  def work_points_sum(point_details, memberships)
    points(point_details, memberships, method(:sum_work_details)).sum
  end

  def responsibility_points_sum(point_details, memberships)
    points(point_details, memberships, method(:sum_responsibility_details)).sum
  end

  def all_points_sum(point_details, memberships)
    points(point_details, memberships, method(:sum_all_details)).sum
  end

  private

  def points(point_details, memberships, method)
    points = []
    memberships.each do |membership|
      sum = method.call(point_details, membership.user)
      points.push sum if sum.positive?
    end
    points
  end
end
