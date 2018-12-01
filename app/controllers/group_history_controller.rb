class GroupHistoryController < ApplicationController
  before_action :require_login

  def show
    @group = current_group
    @evaluations = @group.accepted_evaluations_by_date
    if (params[:semester])
      @evaluation = @evaluations.select { |e| e.semester == params[:semester] }.first
    end
    @evaluation ||= @evaluations.first
    @semester = @evaluation.date_as_semester
  end
end
