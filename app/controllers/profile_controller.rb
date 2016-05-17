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
  
  def new
    @user = User.new
  end

  def save_settings
    raise
    @user = User post
    post[:firstName]
    post[:lastName]
    post[:nickName]

    # a fentieket nem lenne egyszerűbb valami osztályon keresztül behúzni? 
    #  és akkor csak annyi lenne, hogy: User=post
  end
  
end
