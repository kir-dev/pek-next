class CalculatePointHistory
  attr_reader :current_semester, :previous_semester

  def initialize(semester)
    @current_semester = semester
    @previous_semester = semester.previous
  end

  def call
    PointHistory.destroy_all(semester: current_semester.to_s)
    PointRequest.includes([{ evaluation: [:group] }, :user])
                .select { |pr| last_two_semester?(pr.evaluation.semester) }
                .map(&:user)
                .uniq
                .each do |user|
      point = calculate_points(user)
      PointHistory.create(user: user, semester: current_semester, point: point)
    end
  end

  private

  def calculate_points(user)
    user_points = {}
    user.pointrequests
        .includes([{ evaluation: [:group] }])
        .select { |r| valid_point_request?(r) }
        .each do |point_request|
      user_points[point_request.evaluation.group.id] ||= 0
      user_points[point_request.evaluation.group.id] += point_request.point**2
    end
    sum = 0
    user_points.each { |_, point| sum += Math.sqrt(point) }
    [sum, 100].min
  end

  def valid_point_request?(point_request)
    last_two_semester?(point_request.evaluation.date_as_semester) &&
      point_request.evaluation.point_request_accepted?
  end

  def last_two_semester?(semester)
    semester.to_s == current_semester.to_s ||
      semester.to_s == previous_semester.to_s
  end
end
