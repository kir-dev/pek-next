class EvaluationsController < ApplicationController
  # before_action :require_resort_or_group_leader
  # before_action :require_application_or_evaluation_season
  # before_action :require_application_season_for_group_leader
  # before_action :validate_correct_group, except: :current
  # before_action :changeable_points, only: %i[edit update table submit_point_request]
  # before_action :changeable_entries, only: %i[submit_entry_request]
  before_action :authorize_evaluation
  after_action :verify_authorized

  def current
    evaluation = Evaluation.find_by(group_id: current_group.id, semester: current_semester)
    evaluation ||= Evaluation.create(group_id: current_group.id,
                                     creator_user_id: current_user.id,
                                     semester: current_semester)

    redirect_to evaluation_path(evaluation)
  end

  def show
    @evaluation = current_evaluation
    @group = @evaluation.group
  end

  def edit
    current_evaluation
  end

  def update
    current_evaluation.update(params.require(:evaluation).permit(:justification))
    redirect_to gevaluation_path(current_evaluation),
                notice: t(:edit_successful)
  end

  def table
    @point_details =
      PointDetail.includes([{ point_request: [:evaluation] }, :principle, :point_detail_comments]).select do |pd|
        pd.point_request.evaluation == current_evaluation
      end
    @evaluation = current_evaluation
    @group = @evaluation.group
  end

  def submit_entry_request
    current_evaluation.update(entry_request_status: Evaluation::NOT_YET_ASSESSED)

    redirect_to evaluation_path(current_evaluation),
                notice: t(:submitted_entry_request)
  end

  def submit_point_request
    current_evaluation.update(point_request_status: Evaluation::NOT_YET_ASSESSED)

    redirect_to evaluation_path(current_evaluation),
                notice: t(:submitted_point_request)
  end

  def cancel_entry_request
    current_evaluation.update(entry_request_status: Evaluation::NON_EXISTENT)

    redirect_to evaluation_path(current_evaluation),
                notice: t(:cancelled_entry_request)
  end

  def cancel_point_request
    current_evaluation.update(point_request_status: Evaluation::NON_EXISTENT)

    redirect_to evaluation_path(current_evaluation),
                notice: t(:cancelled_point_request)
  end

  private

  def validate_correct_group
    forbidden_page unless current_evaluation.group == current_group
  end

  def changeable_entries
    redirect_to root_url unless current_evaluation.changeable_entry_request_status?
  end

  def changeable_points
    redirect_to root_url unless current_evaluation.changeable_point_request_status?
  end

  def authorize_evaluation
    authorize Evaluation.find_or_initialize_by(group: Group.find(params[:group_id]))
  end
end
