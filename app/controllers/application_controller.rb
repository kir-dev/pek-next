class ApplicationController < ActionController::Base
  include ApplicationHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # better_errors has a bug with puma 3.x that makes it relly slow to load
  # https://github.com/charliesome/better_errors/issues/341
  before_action :better_errors_hack, if: -> { Rails.env.development? }
  def better_errors_hack
    request.env['puma.config'].options.user_options.delete :app
  end

  def require_login
    unless session[:user_id] || ENV['NONAUTH']
      session[:redirect_url] = request.original_fullpath
      redirect_to login_path
    end
  end

  def correct_user
    user = User.find_by(screen_name: params[:id])
    redirect_to(root_url) unless user == current_user
  end

  def require_svie_admin
    redirect_to root_url unless current_user.roles.svie_admin?
  end

  def require_privileges_of_rvt
    unauthorized_page unless current_user.roles.rvt_member?
  end

  def require_rvt_leader
    unauthorized_page unless current_user.roles.rvt_leader?
  end

  def require_resort_leader
    unauthorized_page unless current_user.roles.resort_leader?(current_group)
  end

  def require_resort_or_group_leader
    unauthorized_page unless current_user.leader_of?(current_group) || current_user.roles.resort_leader?(current_group)
  end

  def require_pek_admin
    unauthorized_page unless current_user.roles.pek_admin?
  end

  def current_user
    if ENV['NONAUTH']
      return impersonate_user
    end
    @current_user ||= User.includes([ { memberships: [ :group ] } ]).find(session[:user_id])
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
    render 'application/401', status: :unauthorized
  end

  # TODO delete when we upgrade to Rails5
  # Maybe then the default fallback_location will break the app
  def redirect_back(fallback_location: root_url, **args)
    if request.env['HTTP_REFERER'].present? and request.env['HTTP_REFERER'] != request.env["REQUEST_URI"]
      redirect_to :back, args
    else
      redirect_to fallback_location, args
    end
  end
end
