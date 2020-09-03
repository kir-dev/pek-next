class EvaluationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def update?
    user.leader_of?(evaluation.group) && SystemAttribute.application_season?
  end

  private

  def evaluation
    record
  end
end
