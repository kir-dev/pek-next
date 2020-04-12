class MembershipsController < ApplicationController
  before_action :require_leader, except: :create

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

  private

  def group
    @group ||= Group.find(params[:group_id])
  end
end
