module PointHistoryHelper
  def user_detailed_point_history(pointrequests, semester)
    semester_string = semester.to_s
    pointrequests.select { |pr| pr.accepted? && pr.evaluation.semester == semester_string }
                 .each do |pointrequest|
      yield DetailedPointHistory.new(pointrequest)
    end
  end

  def evaluations_to_semester_options(evaluations)
    evaluations.collect do |evaluation|
      [evaluation.date_as_semester.to_readable, evaluation.semester]
    end
  end

  def group_detailed_point_history(evaluation)
    evaluation.point_requests
              .includes(:user)
              .sort { |a, b| a.user.transliterated_full_name <=> b.user.transliterated_full_name }
              .each do |point_request|
                detailed_point_history = DetailedPointHistory.new(point_request)
                yield PointHistoryDecorator.decorate(detailed_point_history)
              end
  end
end
