class PointDetailPolicy < ApplicationPolicy

  def update?
    EvaluationPolicy.new(user, evaluation).submit_point_request?
  end

  private

  def evaluation
    record
  end
end
