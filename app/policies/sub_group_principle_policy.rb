class SubGroupPrinciplePolicy < ApplicationPolicy
  include SubGroupPolicyHelper

  alias sub_group record

  def index?
    leader_of_the_group? || leader_assistant_of_the_group? || admin_of_the_sub_group? || admin_for_any_sub_group?
  end

  def edit?
    leader_of_the_group? || leader_assistant_of_the_group? || admin_of_the_sub_group?
  end

  alias create? edit?
  alias update? edit?
  alias destroy? edit?

  def leader_of_the_group?
    membership.present? && membership.has_post?(PostType::LEADER_POST_ID)
  end

  def leader_assistant_of_the_group?
    membership.present? && membership.has_post?(PostType::LEADER_ASSISTANT_ID)
  end

  def admin_of_the_sub_group?
    sub_group_membership.present? && sub_group_membership.admin?
  end

  def membership
    @membership ||= user.membership_for(sub_group.group)
  end

  def sub_group_membership
    @sub_group_membership ||= SubGroupMembership.find_by(membership: membership, sub_group: sub_group)
  end
end
