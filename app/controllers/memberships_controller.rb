class MembershipsController < ApplicationController
  before_action :require_login
  before_action :require_leader, only: [:inactivate, :destroy, :reactivate, :archive, :unarchive]

  def create
    @group = Group.find(params[:group_id])
    if @group.user_can_join?(current_user)
      unauthorized_page
    else
      CreateMembership.call(@group, current_user)
      redirect_to :back
    end
  end

  def archive
    membership = Membership.find(params[:membership_id])
    membership.archive!
    membership.user.svie_user.try_inactivate!
  end

  def unarchive
    Membership.find(params[:membership_id]).unarchive!
  end

  def inactivate
    membership = Membership.find(params[:membership_id])
    membership.inactivate!
    membership.user.svie_user.try_inactivate!
  end

  def reactivate
    Membership.find(params[:membership_id]).reactivate!
  end
end
