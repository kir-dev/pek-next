class DevelopmentController < ApplicationController
  skip_before_action :require_login

  def index; end

  def impersonate_someone
    impersonate(User.first)
    impersonated_successfully
  end

  def impersonate_user
    impersonate(User.find(params[:user_id]))
    impersonated_successfully
  end

  def impersonate_role
    case params[:role]
    when 'mezei_user'
      impersonate(User.first)
    when 'group_leader'
      impersonate(Group.kirdev.leader.user)
    when 'rvt_leader'
      impersonate(Group.rvt.leader.user)
    when 'rvt_member'
      impersonate(Group.sssl.leader.user)
    when 'svie_admin'
      impersonate(Group.svie.leader.user)
    when 'pek_admin'
      pek_admin = Group.kirdev.members.find { |user| user.roles.pek_admin? }
      impersonate(pek_admin)
    end
    impersonated_successfully
  end

  private

  def impersonate(user)
    session[:user_id] = user.id
  end

  def impersonated_successfully
    redirect_back fallback_location: development_path, notice: :successful_impersonation
  end
end
