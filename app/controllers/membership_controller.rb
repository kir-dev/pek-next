class MembershipController < ApplicationController
  before_action :require_login
  before_action :before_action_init, only: [:edit, :destroy, :create, :inactivate]

  def before_action_init
    @group = Group.find(params[:group_id])
    @is_member = is_member(@group.id, current_user.id)
    @is_leader = is_leader(@group.id, current_user.id)
  end

  def new
    raise
  end

  # POST /groups/:group_id/membership
  def create  ## apply
    if !@group.users_can_apply || is_member(@group.id, current_user.id)
      raise #TODO: render unathorized exception page
    end
    membership = GroupMembership.create(grp_id: @group.id, usr_id: current_user.id)
    Post.create(grp_member_id: membership.id, pttip_id: GroupMembership::DEFAULT_POST_ID)
    redirect_to :back
  end

  # DELETE /groups/:group_id/membership/:id
  def destroy ## inactivate
    raise
    if @is_leader
      GroupMembership.delete(params[:membership_id])
    end
  end

  def inactivate
#    raise
    if @is_leader
      GroupMembership.update(params[:membership_id], membership_end: Time.now)
    end
    redirect_to group_path(@group.id)
  end

  # GET /groups/:group_id/membership/:id/edit
  def edit ##change_pos
    #raise
    if @is_leader
      raise
    end
  end

  def is_member(grp_id, usr_id)
    return GroupMembership.where(grp_id: grp_id, usr_id: usr_id).length > 0
  end

  def is_leader(grp_id, usr_id)
    return is_member(grp_id, usr_id) && Post.where(
      grp_member_id: GroupMembership.where(
        grp_id: grp_id, usr_id: usr_id)[0].id, pttip_id: GroupMembership::LEADER_POST_ID).length > 0
  end
end
