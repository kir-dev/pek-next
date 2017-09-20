class DelegatesController < ApplicationController
  before_action :require_login
  before_action :require_leader, only: [:show, :create, :destroy]

  def index
    @delegates = User.where(delegated: true).order(:firstname).page(params[:page]).per(params[:per])
  end

  def show
    @eligible_members = @group.members.where(svie_member_type: 'RENDESTAG').order(:lastname)
      .select { |user| user.primary_membership.group_id == params[:group_id].to_i && user.primary_membership.end.nil? }
  end

  def create
    unless @group.can_delegate_more
      redirect_to group_delegates_path(params[:group_id]), alert: t(:too_many_delegates)
      return
    end
    User.find(params[:member_id]).update(delegated: true)
    redirect_to group_delegates_path(params[:group_id])
  end

  def destroy
    User.find(params[:member_id]).update(delegated: false)
    redirect_to group_delegates_path(params[:group_id])
  end

end
