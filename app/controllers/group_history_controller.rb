class GroupHistoryController < ApplicationController
  before_action :redirect_back_with_notice, unless: :has_evaluation_to_show?

  def show
    @group = current_group
    @evaluations = @group.accepted_evaluations_by_date
    if params[:semester]
      @evaluation = @evaluations.select { |e| e.semester == params[:semester] }.first
    end
    @evaluation ||= @evaluations.first
    @semester = @evaluation.date_as_semester
  end

  private

  def has_evaluation_to_show?
    current_group.accepted_evaluations_by_date.any?
  end

  def redirect_back_with_notice
    redirect_back fallback_location: group_path(current_group), alert: t(:does_not_have_evaluation)
  end
end
