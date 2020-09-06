class PointDetailPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def update?
    user.leader_of?(evaluation.group) &&
        evaluation.changeable_point_request_status?
  end

  private

  def evaluation
    record.point_request.evaluation
  end
end
