class ApplicationController < ActionController::Base
  include ApplicationHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  use OmniAuth::Strategies::Developer

  def require_login
    if session[:user_id]
      @curent_user = User.find(session[:user_id])
    else
      render 'layouts/index'
    end
  end
end
