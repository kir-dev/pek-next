class SessionsController < ApplicationController
  def create
    $user = request.env['omniauth.auth']['extra']['raw_info']['displayName']
    puts @user
    redirect_to '/'
  end
end