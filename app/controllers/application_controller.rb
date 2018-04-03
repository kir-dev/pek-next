class ApplicationController < ActionController::Base
  include ApplicationHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def require_login
    redirect_to login_path unless session[:user_id] || ENV['NONAUTH']
  end

  def correct_user
    @user = User.find_by(screen_name: params[:id])
    redirect_to(root_url) unless @user == current_user
  end

  def current_user
    if ENV['NONAUTH']
      return impersonate_user
    end
    @user ||= User.find(session[:user_id])
  end
  helper_method :current_user

  def current_group
    if params[:group_id]
      @group ||= Group.find(params[:group_id])
    else
      @group ||= Group.find(params[:id])
    end
    @group
  end
  helper_method :current_group

  def require_leader
    membership = current_user.membership_for(current_group)
    unauthorized_page unless membership && membership.leader?
  end

  def impersonate_user
    @user ||= User.first
  end

  def unauthorized_page
    render 'application/401'
  end
end
