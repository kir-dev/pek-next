class MembershipController < ApplicationController
  before_action :require_login
  before_action :before_action_init, only: [:destroy, :create, :inactivate]

  def before_action_init
    @group = Group.find(params[:group_id])
    @own_membership = current_user.memberships.find { |m| m.group == @group }
  end

  # POST /groups/:group_id/membership
  def create  ## apply
    if !@group.users_can_apply || is_member(@group.id, current_user.id)
      raise #TODO: render unathorized exception page
    end
    membership = Membership.create(grp_id: @group.id, usr_id: current_user.id)
    Post.create(grp_member_id: membership.id, pttip_id: Membership::DEFAULT_POST_ID)
    redirect_to :back
  end

  # DELETE /groups/:group_id/membership/:id
  def destroy ## inactivate
    raise
    if @own_membership.is_leader
      Membership.delete(params[:membership_id])
    end
  end

  def inactivate
#    raise
    if @own_membership.is_leader
      Membership.update(params[:membership_id], membership_end: Time.now)
    end
    redirect_to group_path(@group.id)
  end

end
