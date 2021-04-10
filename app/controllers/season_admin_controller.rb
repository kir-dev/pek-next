class SeasonAdminController < ApplicationController
  before_action :require_rvt_leader

  def index
    @season = SystemAttribute.season
    @semester = SystemAttribute.semester.to_readable
    @isCurrent = SystemAttribute.semester.current?
  end

  def next
    SystemAttribute.update_semester SystemAttribute.semester.next!
    redirect_to season_index_path
  end

  def previous
    SystemAttribute.update_semester SystemAttribute.semester.previous!
    redirect_to season_index_path
  end

end
