class MembershipController < ApplicationController
  before_action :require_login
  before_action :before_action_init, only: [:destroy, :create, :inactivate]

  def before_action_init
    @group = Group.find(params[:group_id])
    @own_membership = current_user.memberships.find { |m| m.group == @group }
  end

  # POST /groups/:group_id/membership
  def create  ## apply
    if !@group.users_can_apply || @own_membership
      unauthorized_page
    else
      membership = Membership.create(grp_id: @group.id, usr_id: current_user.id)
      Post.create(grp_member_id: membership.id, pttip_id: Membership::DEFAULT_POST_ID)
      redirect_to :back
    end
  end

  def destroy
    if is_leader
      Membership.delete(params[:membership_id])
      redirect_to group_path(@group.id)
    else
      unauthorized_page
    end
  end

  def inactivate
    if is_leader
      Membership.update(params[:membership_id], membership_end: Time.now)
      redirect_to group_path(@group.id)
    else
      unauthorized_page
    end
  end

  private

  def is_leader
    @own_membership && @own_membership.is_leader
  end

end
