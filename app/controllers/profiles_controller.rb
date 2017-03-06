class ProfilesController < ApplicationController
  before_action :require_login
  before_action :correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
  end

  def show_self
    @user = current_user
    render :show
  end

  def edit
    @user = User.find_by(screen_name: params[:id])
  end

  def update
    @user = current_user

    if @user.update(update_params)
      redirect_to profiles_me_path
    else
      render :edit
    end
  end

  private

  def update_params
    params.permit(:firstname, :lastname, :nickname, :gender, :date_of_birth,
      :home_address, :email, :webpage, :dormitory, :room, :cell_phone)
  end
end
