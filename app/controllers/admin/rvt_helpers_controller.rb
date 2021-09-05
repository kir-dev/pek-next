class Admin::RvtHelpersController < ApplicationController
  before_action :set_user, only: [:add, :remove]
  before_action :require_rvt_leader, only: [:add, :remove]
  before_action :require_privileges_of_rvt

  def index
    @users = User.where(rvt_helper: true).decorate
  end

  def add
    @user.update!(rvt_helper: true)
  end

  def remove
    @user.update!(rvt_helper: false)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
