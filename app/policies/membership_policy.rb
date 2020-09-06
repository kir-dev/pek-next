class MembershipPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def change_status?
    user.leader_of?(group)
  end

  private

  def group
    record.group
  end
end
