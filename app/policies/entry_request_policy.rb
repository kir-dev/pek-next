class EntryRequestPolicy < ApplicationPolicy
  private

  def evaluation
    record
  end
end
