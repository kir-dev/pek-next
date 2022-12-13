class SubGroupPolicy < ApplicationPolicy
  alias sub_group record

  def index?
    return true if member_of_the_group?
  end

  alias show? index?

  def create?
    return true if leader_of_the_group?
  end

  alias edit? create?
  alias set_admin? create?
  alias new? create?
  alias update? create?
  alias destroy? create?

  def join?
    member_of_the_group?
  end

  alias leave? join?

  private

  def member_of_the_group?
    membership.present? && membership.active?
  end

  def leader_of_the_group?
    membership.present? && membership.has_post?(PostType::LEADER_POST_ID)
  end

  def membership
    user.membership_for(sub_group.group)
  end
end
