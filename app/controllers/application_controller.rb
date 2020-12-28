class ApplicationController < ActionController::Base
  include ApplicationHelper
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from Pundit::NotAuthorizedError, with: :forbidden_page

  before_action :require_login
  def require_login
    return if session[:user_id] || ENV['NONAUTH']

    session[:redirect_url] = request.original_fullpath
    redirect_to login_path
  end

  before_action :set_notifications
  def set_notifications
    @notifications = current_user.notifications.unopened_only if session[:user_id]
  end

  def correct_user
    user = User.find_by(screen_name: params[:id])
    redirect_to(root_url) unless user == current_user
  end

  def require_svie_admin
    redirect_to root_url unless current_user.roles.svie_admin?
  end

  def require_privileges_of_rvt
    forbidden_page unless current_user.roles.rvt_member?
  end

  def require_rvt_leader
    forbidden_page unless current_user.roles.rvt_leader?
  end

  def require_resort_leader
    forbidden_page unless current_user.roles.resort_leader?(current_group)
  end

  def require_resort_or_group_leader
    forbidden_page unless current_user.leader_of?(current_group) ||
							 current_user.roles.resort_leader?(current_group)
  end

  def require_resort_or_group_leader_or_rvt_member
    forbidden_page unless current_user.leader_of?(current_group) ||
							 current_user.roles.resort_leader?(current_group) ||
							 current_user.roles.rvt_member?
  end

  def require_pek_admin
    forbidden_page unless current_user.roles.pek_admin?
  end

  def require_application_or_evaluation_season
    redirect_to root_url if SystemAttribute.offseason?
  end

  def require_application_season_for_group_leader
    redirect_to root_url if current_user.leader_of?(current_group) && !SystemAttribute.application_season?
  end

  def require_leader_or_rvt_member
    membership = current_user.membership_for(current_group)
    forbidden_page unless membership&.leader? || current_user.roles.rvt_member?
  end

  def current_semester
    SystemAttribute.semester.to_s
  end

  def current_user
    return impersonate_user if ENV['NONAUTH']

    @current_user ||= User.includes([{ memberships: [:group] }]).find(session[:user_id])
  end
  helper_method :current_user

  def current_group
    return @group ||= Group.find(params[:group_id]) if params[:group_id]

    @group ||= Group.find(params[:id])
  end
  helper_method :current_group

  def current_evaluation
    @current_evaluation ||= Evaluation.includes(:principles)
                                      .find(params[:evaluation_id] || params[:id])
  rescue ActiveRecord::RecordNotFound
    Evaluation.find_or_initialize_by(group: current_group, semester: current_semester)
  end
  helper_method :current_evaluation

  def require_leader
    membership = current_user.membership_for(current_group)
    forbidden_page unless membership&.leader?
  end

  def impersonate_user
    @user ||= User.first
  end

  def forbidden_page
    render 'application/403', status: :forbidden
  end
end
