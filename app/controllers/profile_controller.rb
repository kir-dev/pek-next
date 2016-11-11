class ProfileController < ApplicationController
  include ApplicationHelper

  def show
    if session[:user]
      if params.key?(:number)
        id = params[:number]
      else
        id = session[:user]
      end
      @user = User.find(id)
    else
      redirect_to oauth_login_path
    end
  end

end
