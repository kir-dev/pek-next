class SeasonAdminController < ApplicationController
  before_action :require_rvt_leader

  def index
    @season = SystemAttribute.season
    @semester = SystemAttribute.semester
    @isCurrent = SystemAttribute.semester.current?
  end

  def next
    SystemAttribute.update_semester SystemAttribute.semester.next!
    puts SystemAttribute.semester
    redirect_to '/seasons'
  end

  def previous
    SystemAttribute.update_semester SystemAttribute.semester.previous!
    puts SystemAttribute.semester
    redirect_to '/seasons'
  end

  def update
    SystemAttribute.update_season(params[:season])
    Semester.from_year(params[:semester_year], params[:semester_semester]).save
    redirect_to root_path, notice: t(:edit_successful)
  end
end
