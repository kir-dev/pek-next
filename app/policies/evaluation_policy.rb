class EvaluationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def current?
    (group_leader || resort_laeder) && !SystemAttribute.offseason?
  end

  def show?
    (group_leader || resort_laeder) && !SystemAttribute.offseason?
  end

  def table?
    (group_leader || resort_laeder) && !SystemAttribute.offseason?
  end

  def edit?
    group_leader || SystemAttribute.application_season?
  end

  def update?
    edit?
  end

  def submit_entry_request
    group_leader && evaluation
  end

  def cancel_entry_request
    group_leader
  end

  def submit_point_request
    group_leader
  end

  def cancel_poin_request
    group_leader
  end

  private

  def resort_laeder
    user.leader_of?(evaluation.group.parent)
  end

  def group_leader
    user.leader_of?(evaluation.group)
  end

  def evaluation
    record
  end
end
