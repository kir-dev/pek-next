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
  end

  def update
    if current_group.update(update_params)
      redirect_to current_group, notice: t(:edit_successful)
    else
      render :edit
    end
  end

  private

  def update_params
    params.require(:group).permit(:name, :description, :webpage, :founded, :maillist, :users_can_apply)
  end

end
