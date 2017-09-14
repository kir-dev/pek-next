class GroupsController < ApplicationController
  before_action :require_login
  before_action :require_leader, only: [:edit, :update]

  def index
    @groups = Group.order(:name).page(params[:page]).per(params[:per])
  end

  def show
    @viewmodel = Group::MembershipViewModel.new(current_user, params[:id])
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(update_params)
      redirect_to @group, notice: t(:edit_successful)
    else
      render :edit
    end
  end

  def is_leader
    @own_membership && @own_membership.is_leader
  end
  helper_method :is_leader

  private

  def require_leader
    unauthorized_page unless is_leader
  end

  def update_params
    params.require(:group).permit(:name, :description, :webpage, :founded, :maillist, :users_can_apply)
  end

end
