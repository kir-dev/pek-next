class EvaluationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def update?
    user.leader_of?(evaluation.group) ||
        (user.leader_of?(evaluation.group.parent) && !SystemAttribute.offseason?)
  end

  private

  def evaluation
    record
  end
end
