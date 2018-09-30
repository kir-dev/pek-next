module PointHistoryHelper
  def detailed_point_history(pointrequests, semester)
    semester_string = semester.to_s
    pointrequests.select { |pr| pr.accepted? && pr.evaluation.semester == semester_string }
                 .each do |pointrequest|
      yield DetailedPointHistory.new(pointrequest)
    end
  end
end
