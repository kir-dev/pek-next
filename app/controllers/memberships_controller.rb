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
    membership_id = params[:id]

    membership = Membership.find(membership_id)
    if membership.user.delegated && membership.user.primary_membership == membership
      Membership.find(membership_id).user.update(delegated: false)
    end

    Membership.delete(membership_id)
  end

  def inactivate
    membership_id = params[:membership_id]
    Membership.update(membership_id, membership_end: Time.now)

    membership = Membership.find(membership_id)
    if membership.user.delegated && membership.user.primary_membership == membership
      Membership.find(membership_id).user.update(delegated: false)
    end
  end

  def reactivate
    Membership.update(params[:membership_id], membership_end: nil)
  end
end
