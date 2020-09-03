class PointDetailPolicy < EvaluationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  private

  def evaluation
    record.point_request.evaluation
  end
end
