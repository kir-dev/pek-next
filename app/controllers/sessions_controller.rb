class SessionsController < ApplicationController

  def new
  end

  def destroy
    reset_session
    redirect_to root_url
  end

  def create
    raw_user = request.env['omniauth.auth']['extra']['raw_info']
    redirect_url = session[:redirect_url] || root_path
    user = User.find_by(auth_sch_id: raw_user['internal_id'])
    if user
      session[:user_id] = user.id
      user.update_last_login!
      redirect_to redirect_url
    else
      session[:oauth_data] = raw_user
      redirect_to register_path
    end
  end
end
