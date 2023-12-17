class SubGroupPrinciplePolicy < ApplicationPolicy
  alias principle record

  def index?
    return if SystemAttribute.season.value == SystemAttribute::OFFSEASON
    return unless principle.evaluation&.semester == SystemAttribute.semester.to_s

    leader_of_the_group? || leader_assistant_of_the_group? || admin_of_the_sub_group?
  end

  alias create? index?
  alias update? create?
  alias destroy? create?

  def leader_of_the_group?
    membership.present? && membership.has_post?(PostType::LEADER_POST_ID)
  end

  def leader_assistant_of_the_group?
    membership.present? && membership.has_post?(PostType::LEADER_ASSISTANT_ID)
  end

  def admin_of_the_sub_group?
    sub_group_membership.present? && sub_group_membership.admin?
  end

  def sub_group
    @sub_group ||= principle.sub_group
  end

  def membership
    @membership ||= user.membership_for(sub_group.group)
  end

  def sub_group_membership
    @sub_group_membership ||= SubGroupMembership.find_by(membership: membership, sub_group: sub_group)
  end
end
