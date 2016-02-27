class ProfileController < ApplicationController

  def show
  	if session[:user]
    	@user = User.find(session[:user])
    else
    	redirect_to '/auth/oauth'
    end
  end

  def settings
  	if session[:user]
    	@user = User.find(session[:user])
      @genders = '{"UNKNOWN", "MALE", "FEMALE", "NOTSPECIFIED"}'#FIXME
    else
    	redirect_to '/auth/oauth'
    end
  end

  
end
