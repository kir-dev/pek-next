class GroupsController < ApplicationController
  before_action :require_login

  def index
    @groups = Group.order(:name).page(params[:page]).per(params[:per])
  end

  def show
    @viewmodel = Group::MembershipViewModel.new(current_user, params[:id])
  end

  def delegates
    @group = Group.find(params[:group_id])
    @eligible_members = @group.members.where(svie_member_type: 'RENDESTAG').order(:lastname)
      .select { |user| user.primary_membership.group_id == params[:group_id].to_i && user.primary_membership.end.nil? }
  end

  def set_delegate
    @group = Group.find(params[:group_id])
    delegates = @group.members.where(delegated: true).select { |user| user.primary_membership.group_id == params[:group_id].to_i && user.primary_membership.end.nil? }
    delegate_count = delegates.length + 1
    if delegate_count > @group.delegate_count
      redirect_to group_delegates_path(params[:group_id]), alert: t(:too_many_delegates)
      return
    end
    User.find(params[:member_id]).update(delegated: true)
    redirect_to group_delegates_path(params[:group_id])
  end

  def delete_delegate
    User.find(params[:member_id]).update(delegated: false)
    redirect_to group_delegates_path(params[:group_id])
  end
end
