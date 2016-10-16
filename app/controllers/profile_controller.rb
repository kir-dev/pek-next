class ProfileController < ApplicationController

  def show
    if session[:user]
      if params.key?(:number)
        id = params[:number]
      else
        id = session[:user]
      end
      @user = User.find(id)
    else
      redirect_to '/auth/oauth'
    end
  end

end
