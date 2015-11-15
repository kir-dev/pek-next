class ProfileController < ApplicationController

  def show
    @user = User.find(session[:user])
  end
  
end
