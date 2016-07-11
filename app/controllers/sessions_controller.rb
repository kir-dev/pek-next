class SessionsController < ApplicationController

  def create
    oauth_data = request.env['omniauth.auth']['extra']['raw_info']
    user = User.find_by(usr_auth_sch_id: oauth_data['internal_id'])
    if !user
      session[:oauth_data] = oauth_data
      redirect_to action: :new, controller: :registration
    else
      session[:user] = user.id
      redirect_to '/'
    end
  end

end