class SeasonAdminController < ApplicationController
  before_action :require_login
  before_action :require_rvt_leader

  def index
    @season = SystemAttribute.season
    @semester = SystemAttribute.semester
  end

  def update
    SystemAttribute.update_season(params[:season])
    Semester.from_year(params[:semester_year], params[:semester_semester]).save
    redirect_to root_path, notice: t(:edit_successful)
  end

end
