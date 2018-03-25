class MembershipsController < ApplicationController
  before_action :require_login
  before_action :require_leader, only: [:inactivate, :destroy, :reactivate, :archive, :unarchive]

  def create
    @group = Group.find(params[:group_id])
    if @group.user_can_join?(current_user)
      CreateMembership.call(@group, current_user)
      redirect_to :back
    else
      unauthorized_page
    end
  end

  def archive
    Membership.find(params[:membership_id]).archive!
  end

  def unarchive
    Membership.find(params[:membership_id]).unarchive!
  end

  def inactivate
    Membership.find(params[:membership_id]).inactivate!
  end

  def reactivate
    Membership.find(params[:membership_id]).reactivate!
  end
end
