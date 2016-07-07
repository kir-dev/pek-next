class ProfileController < ApplicationController

  def show
  	if session[:user]
    	@user = User.find(session[:user])
    else
    	redirect_to '/auth/oauth'
    end
  end
  
  def register
    @dorms = [ "Schönherz Zoltán Kollégium", "Nagytétényi úti Kollégium", "Vásárhelyi", "Kármán", "Külsős" ]
  end
end
