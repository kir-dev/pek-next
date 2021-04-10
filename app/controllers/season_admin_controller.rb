class SeasonAdminController < ApplicationController
  before_action :require_rvt_leader

  def index
    @season = SystemAttribute.season
    @semester = SystemAttribute.semester
    @current_semester = Semester.current
  end

  def next
    SystemAttribute.update_semester SystemAttribute.semester.next!
    redirect_to seasons_path
  end

  def previous
    SystemAttribute.update_semester SystemAttribute.semester.previous!
    redirect_to seasons_path
  end

end
