require 'fileutils'

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
    current_user.update(
      params.permit(
        :firstname,
        :lastname,
        :nickname,
        :gender,
        :date_of_birth,
        :home_address,
        :email,
        :webpage,
        :dormitory,
        :room
      )
    )

    phone_regex = /^[0-9\+][0-9\-]+$/.match(params['cell_phone'])

    if phone_regex or params['cell_phone'] == ''
      current_user.cell_phone = phone_regex
      current_user.save
      redirect_to edit_profile_path
    else
      @error = { expected: true }
      @error[:message] = I18n.t 'error.wrong_phone_number'
      render :edit
    end
  end
end
