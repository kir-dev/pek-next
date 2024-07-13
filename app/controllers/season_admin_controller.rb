class SeasonAdminController < ApplicationController
  before_action :require_rvt_leader

  def index
    @season = SystemAttribute.season
    @semester = SystemAttribute.semester
  end

  def next
    SystemAttribute.update_semester SystemAttribute.semester.next!
    redirect_to seasons_path, notice: t(:edit_successful)
  end

  def previous
    SystemAttribute.update_semester SystemAttribute.semester.previous!
    redirect_to seasons_path, notice: t(:edit_successful)
  end

  def update
    SystemAttribute.update_season(params[:season])
    redirect_to seasons_path, notice: t(:edit_successful)
  end

  def export
    semester = SystemAttribute.semester
    export = ExportPointHistory.call(semester.to_s)
    csv = CSV.generate do |lines|
      export.each do |line|
        lines << line
      end
    end
    send_data(csv, filename: "kozossegi-pont-expot-#{semester}.csv", type: "text/csv")
  end
end
