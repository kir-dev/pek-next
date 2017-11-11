class MembershipsController < ApplicationController
  before_action :require_login
  before_action :require_leader, only: [:inactivate, :destroy, :reactivate]

  def create
    @group = Group.find(params[:group_id])
    if @group.user_can_join?(current_user)
      unauthorized_page
    else
      CreateMembership.call(@group, current_user)
      redirect_to :back
    end
  end

  def destroy
    Membership.delete(params[:id])
  end

  def inactivate
    Membership.find(params[:membership_id]).inactivate!
  end

  def reactivate
    Membership.find(params[:membership_id]).reactivate!
  end
end
