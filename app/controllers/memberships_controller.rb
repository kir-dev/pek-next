class MembershipsController < ApplicationController
  before_action :require_login
  before_action :require_leader, only: [:inactivate, :destroy, :reactivate, :archive, :unarchive, :accept]

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

  def accept
    Membership.find(params[:membership_id]).accept!
  end
end
