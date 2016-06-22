class SessionsController < ApplicationController
  def create
    oauth_data = request.env['omniauth.auth']['extra']['raw_info']
    user = User.find_by usr_auth_sch_id: oauth_data['internal_id']
    if !user
      session[:oauth_data] = oauth_data
      redirect_to '/register'
    else
      session[:user] = user.id
      redirect_to '/'
    end
  end

  def register
    user = User.create(usr_auth_sch_id: session[:oauth_data]["internal_id"],
      email: session[:oauth_data]["mail"],
      firstname: session[:oauth_data]["givenName"], 
      lastname: session[:oauth_data]["sn"],
      screen_name: request.params[:username],
      dormitory: request.params[:dormitory],
      room: request.params[:room])
    session[:user] = user.id
    redirect_to '/'
  end
end