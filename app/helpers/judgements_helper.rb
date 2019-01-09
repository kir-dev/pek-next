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

  def work_points_average(point_details, memberships)
    average(points(point_details, memberships, method(:sum_work_details)))
  end

  def responsibility_points_average(point_details, memberships)
    average(points(point_details, memberships, method(:sum_responsibility_details)))
  end

  def all_points_average(point_details, memberships)
    average(points(point_details, memberships, method(:sum_all_details)))
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

  def average(points_array)
    return 0 if points_array.empty?

    average = points_array.sum / points_array.size.to_f
    average.round(2)
  end
end
