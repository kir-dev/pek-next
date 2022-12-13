class PointDetailPolicy < EvaluationPolicy
  attr_reader :principle

  def initialize(current_user, evaluation, principle = nil)
    @principle = principle
    super(current_user, evaluation)
  end

  def can_update_active_request?
    super || sub_group_admin?
  end

  private

  def sub_group
    principle&.sub_group
  end

  def membership
    user.membership_for(evaluation&.group)
  end

  def sub_group_membership
    SubGroupMembership.find_by(membership: membership, sub_group: sub_group)
  end

  def sub_group_admin?
    sub_group_membership&.admin?
  end
end
