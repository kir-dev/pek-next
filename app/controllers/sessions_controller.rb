class SessionsController < ApplicationController
  def create
    @user = request.env['omniauth.auth']['extra']['raw_info']
    user = User.find_by usr_auth_sch_id: @user['internal_id']
    session[:user] = user.id
    redirect_to '/'
  end
end