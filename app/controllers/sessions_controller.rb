class SessionsController < ApplicationController
  def create
    @user = request.env['omniauth.auth']['extra']['raw_info']
    user = User.find_by(usr_auth_sch_id: @user['internal_id'])
    session[:user_id] = user.id
    redirect_to root_path
  end
end