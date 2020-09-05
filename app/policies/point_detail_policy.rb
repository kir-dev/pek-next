class PointDetailPolicy < EvaluationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def update?
    return false unless evaluation.changeable_point_request_status?

    super
  end

  private

  def evaluation
    record.point_request.evaluation
  end
end
