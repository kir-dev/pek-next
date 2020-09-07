class EntryRequestPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def update?
    user.leader_of?(evaluation.group) &&
        evaluation.changeable_entry_request_status?
  end

  private

  def evaluation
    record.evaluation
  end
end
