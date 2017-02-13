class ApplicationController < ActionController::Base
  include ApplicationHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  use OmniAuth::Strategies::Developer

  def require_login
    redirect_to oauth_login_path unless session[:user] || ENV['NONAUTH']
  end

  def current_user
    if ENV['NONAUTH']
      return impersonate_user
    end
    @user ||= User.find(session[:user])
  end
  helper_method :current_user

  def impersonate_user
    @user ||= User.first
  end
end
