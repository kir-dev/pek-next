class ApplicationController < ActionController::Base
  include ApplicationHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  use OmniAuth::Strategies::Developer

  def require_login
    if session[:user_id]
      @user = User.find(session[:user_id])
    else
      redirect_to oauth_login_path
    end
  end
end
