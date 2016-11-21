class ProfilesController < ApplicationController
  before_action :require_login

  def show
    @user = User.find(params[:id])
  end

  def show_self
    @user = @curent_user
    render :show
  end

end
