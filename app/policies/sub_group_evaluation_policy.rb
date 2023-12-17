# frozen_string_literal: true

class SubGroupEvaluationPolicy < ApplicationPolicy
  alias sub_group record

  def table?
    return false if off_season?

    EvaluationPolicy.new(user, evaluation).table? || admin_of_the_sub_group? || sub_group_admin?
  end

  def update_point_request?
    return false if off_season?

    EvaluationPolicy.new(user, evaluation).table? || admin_of_the_sub_group?
  end

  def update_entry_request?
    EvaluationPolicy.new(user, evaluation).update_entry_request?
  end

  private
  def sub_group_admin?
    sub_group.group.sub_groups.any? do |sub_group_in_group|
      sub_group_in_group.sub_group_memberships_for(user: user)&.admin?
    end
  end
  def off_season?
    SystemAttribute.offseason?
  end

  def evaluation
    sub_group.group.current_evaluation
  end

  def admin_of_the_sub_group?
    sub_group_membership&.admin?
  end

  def sub_group_membership
    SubGroupMembership.find_by(membership: membership, sub_group: sub_group)
  end

  def membership
    user.membership_for(sub_group.group)
  end
end
