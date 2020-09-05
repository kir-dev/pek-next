class MembershipsController < ApplicationController
  # before_action :require_leader, except: %i[create withdraw]
  # before_action :forbidden_page, unless: :membership_belongs_to_user?, only: %i[withdraw]

  def create
    Membership::CreateService.call(group, current_user)

    redirect_back(fallback_location: group_path(group))
  rescue Membership::CreateService::AlreadyMember, Membership::CreateService::GroupNotReceivingNewMembers
    forbidden_page
  end

  def archive
    membership = Membership.find(params[:membership_id])
    return forbidden_page if membership.archived?

    membership.archive!
    membership.user.svie.try_inactivate!
  end

  def unarchive
    membership = Membership.find(params[:membership_id])
    return forbidden_page if !membership.archived? || membership.inactive?

    membership.unarchive!
  end

  def inactivate
    membership = Membership.find(params[:membership_id])
    membership.inactivate!
    membership.user.svie.try_inactivate!
  end

  def reactivate
    Membership.find(params[:membership_id]).reactivate!
  end

  def accept
    Membership.find(params[:membership_id]).accept!
  end

  def withdraw
    Membership::WithdrawService.call(membership)

    redirect_back(fallback_location: group_path(membership.group))
  rescue Membership::WithdrawService::MembershipMustHaveDefaultPost
    forbidden_page
  end

  private

  def group
    @group ||= Group.find(params[:group_id]) || Group.find(params[:id])
  end

  def membership
    @membership ||= Membership.find(params[:id])
  end

  def membership_belongs_to_user?
    membership.user == current_user
  end
end
