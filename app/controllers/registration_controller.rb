class RegistrationController < ApplicationController
  
  def new
    @dorms = Rails.configuration.x.dorms
  end

  def create_user
    user = User.create(usr_auth_sch_id: session[:oauth_data]["internal_id"],
      email: session[:oauth_data]["mail"],
      firstname: session[:oauth_data]["givenName"], 
      lastname: session[:oauth_data]["sn"],
      screen_name: request.params[:username],
      dormitory: request.params[:dormitory],
      room: request.params[:room])
    session[:user] = user.id
    session.delete(:oauth_data)
    redirect_to root_url
  end

end
