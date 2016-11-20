class ProfilesController < ApplicationController
  include ApplicationHelper

  def show
    if session[:user_id]
      if params.key?(:number)
        id = params[:number]
      else
        id = session[:user_id]
      end
      @user = User.find(id)
    else
      redirect_to oauth_login_path
    end
  end

end
