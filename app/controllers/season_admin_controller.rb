class SeasonAdminController < ApplicationController
  before_action :require_rvt_leader
  before_action :require_off_season, only: [:export_point_history, :export_active_users, :export_users_with_ab]

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

  def export_point_history
    semester = SystemAttribute.semester
    export = ExportPointHistory.call(semester.to_s)
    csv = array_to_csv(export)
    send_data(csv, filename: "kozossegi-pont-expot-#{semester}.csv", type: "text/csv")
  end

  def export_entry_requests
    semester = SystemAttribute.semester
    export = ExportEntryRequests.call(semester.to_s)
    csv = array_to_csv(export)
    send_data(csv, filename: "szinesbelepo-export-#{semester}.csv", type: "text/csv")
  end

  def export_active_users
    semester = SystemAttribute.semester
    export = ExportActiveUsers.call(semester.to_s)
    csv = array_to_csv(export)
    send_data(csv, filename: "aktiv-kozelok-export-#{semester}.csv", type: "text/csv")
  end
end
