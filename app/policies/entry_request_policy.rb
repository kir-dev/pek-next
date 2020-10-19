class EntryRequestPolicy < ApplicationPolicy
  def update?
    EvaluationPolicy.new(user, evaluation).submit_entry_request?
  end

  private

  def evaluation
    record
  end
end
