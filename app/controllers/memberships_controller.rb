class MembershipsController < ApplicationController
  before_action :require_login
  before_action :init, only: [:destroy, :create, :inactivate, :reactivate]
  before_action :require_leader, only: [:inactivate, :destroy, :reactivate]

  def init
    @group = Group.find(params[:group_id])
    @own_membership = current_user.membership_for(@group)
  end

  def create
    if @group.user_can_join?(current_user)
      unauthorized_page
    else
      membership = Membership.create(grp_id: @group.id, usr_id: current_user.id)
      Post.create(grp_member_id: membership.id, pttip_id: Membership::DEFAULT_POST_ID)
      redirect_to :back
    end
  end

  def destroy
    Membership.delete(params[:id])
  end

  def inactivate
    Membership.update(params[:membership_id], membership_end: Time.now)
  end

  def reactivate
    Membership.update(params[:membership_id], membership_end: nil)
  end

  private

  def require_leader
    unauthorized_page unless @own_membership && @own_membership.is_leader
  end

end
