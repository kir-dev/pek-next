class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  use OmniAuth::Strategies::Developer

  def require_login
    if session[:user]
      @user = User.find(session[:user])
    else
      redirect_to '/auth/oauth'
    end
  end
end
