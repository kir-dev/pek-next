class GroupsController < ApplicationController
  before_action :require_login

  def index
    @groups = Group.order(:name).page(params[:page]).per(params[:per])
  end

  def show
    @viewmodel = Group::MembershipViewModel.new(current_user, params[:id])
  end

  def delegates
    @eligible_members = Group.find(params[:group_id]).members.where(svie_member_type: 'RENDESTAG')
      .select { |user| user.primary_membership.group_id == params[:group_id].to_i && user.primary_membership.end.nil? }
  end

  def set_delegate
    # Maybe it should be in the delegate controller
    User.find(params[:member_id]).update(delegated: true)
    redirect_to group_delegates_path(params[:group_id])
  end

  def delete_delegate
    # Maybe it should be in the delegate controller
    User.find(params[:member_id]).update(delegated: false)
    redirect_to group_delegates_path(params[:group_id])
  end
end
