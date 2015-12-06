class SessionsController < ApplicationController
  def create
    $user = request.env['omniauth.auth']['extra']['raw_info']
    user = User.find_by usr_auth_sch_id: $user['internal_id']
    if !user
      redirect_to '/register'
    else
      session[:user] = user.id
      redirect_to '/'
    end
  end

  def register
    user = User.create(usr_auth_sch_id: $user[:internal_id],
      email: $user[:mail],
      firstname: $user[:givenName], 
      lastname: $user[:sn],
      screen_name: request.params[:username],
      dormitory: request.params[:dormitory],
      room: request.params[:room])
      session[:user] = user.id
      redirect_to '/'
  end
end