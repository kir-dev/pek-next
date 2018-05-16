class ProfilesController < ApplicationController
  before_action :require_login
  before_action :correct_user, only: [:edit, :update]

  def show
    user = User.includes( [ { pointrequests: [ { evaluation: [ :group, :entry_requests ] } ] },
      { memberships: [ :group, :post_types ] } ]).find_by(screen_name: params[:id])
    return redirect_to profiles_me_path unless user
    @user_presenter = user.decorate
  end

  def show_self
    @user_presenter = current_user.decorate
    render :show
  end

  def edit
    @imAccount = ImAccount.new
    @user = User.find_by(screen_name: params[:id])
  end

  def update
    @user = current_user

    if @user.update(update_params)
      redirect_to profiles_me_path, notice: t(:edit_successful)
    else
      render :edit
    end
  end

  private

  def update_params
    params.require(:profile).permit(:firstname, :lastname, :nickname, :gender,
      :date_of_birth, :home_address, :email, :webpage, :dormitory, :room, :cell_phone)
  end
end
