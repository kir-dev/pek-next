class MembershipsController < ApplicationController
  before_action :authorize_membership, except: :create

  def create
    Membership::CreateService.call(group, current_user)

    redirect_back(fallback_location: group_path(group))
  rescue Membership::CreateService::AlreadyMember, Membership::CreateService::GroupNotReceivingNewMembers
    forbidden_page
  end

  def archive
    return forbidden_page if membership.archived?

    membership.archive!
    membership.user.svie.try_inactivate!
  end

  def unarchive
    return forbidden_page if !membership.archived? || membership.inactive?

    membership.unarchive!
  end

  def inactivate
    membership.inactivate!
    membership.user.svie.try_inactivate!
  end

  def reactivate
    membership.reactivate!
  end

  def accept
    membership.accept!
  end

  def withdraw
    Membership::WithdrawService.call(membership)

    redirect_to(group_path(group)) if membership.user == current_user
  rescue Membership::WithdrawService::WithdrawError
    forbidden_page
  end

  private

  def group
    @group ||= Group.find(params[:group_id])
  end

  def membership
    membership_id = params[:id] || params[:membership_id]
    @membership ||= Membership.find(membership_id)
  end

  def authorize_membership
    authorize membership
  end
end
