class DevelopmentController < ApplicationController

  def index
  end

  def impersonate_someone
    impersonate(User.first.id)
    redirect_to :back
  end

  def impersonate_user
    impersonate(params[:user_id])
    redirect_to :back
  end

  def impersonate_role
    case params[:role]
    when :mezei_user
      impersonate(User.first.id)
    end
    redirect_to :back
  end

  private

  def impersonate(user_id)
    session[:user_id] = user_id
  end

end
