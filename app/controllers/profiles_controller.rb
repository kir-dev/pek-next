class ProfilesController < ApplicationController
  before_action :require_login

  def show
    if params.key?(:number)
      id = params[:number]
    else
      id = session[:user_id]
    end
    @user = User.find(id)
  end

end
