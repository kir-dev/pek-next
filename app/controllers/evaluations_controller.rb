class EvaluationsController < ApplicationController
  before_action :validate_correct_group

  def current
    authorize_evaluation

    evaluation = Evaluation.find_by(group_id: current_group.id, semester: current_semester)
    evaluation ||= new_evaluation

    redirect_to group_evaluation_path(evaluation.group, evaluation)
  end

  def show
    authorize_evaluation

    @evaluation = current_evaluation
  end

  def edit
    authorize_evaluation

    @evaluation = Evaluation.find_by(group_id: current_group.id, semester: current_semester)
  end

  def update
    authorize_evaluation

    current_evaluation.update(params.require(:evaluation).permit(:justification))
    redirect_to group_evaluation_path(current_evaluation.group, current_evaluation),
                notice: t(:edit_successful)
  end

  def table
    authorize_evaluation

    @point_details =
      PointDetail.includes([{ point_request: [:evaluation] }, :principle, :point_detail_comments]).select do |pd|
        pd.point_request.evaluation == current_evaluation
      end
    @evaluation    = current_evaluation
    @point_eligible_memberships = @evaluation.group.point_eligible_memberships.sort{|a, b| hu_compare(a.user.full_name, b.user.full_name)}
    @evaluation_policy = policy(@evaluation)
    @ordered_principles = @evaluation.ordered_principles
  end

  def submit_entry_request
    authorize_evaluation
    current_evaluation.update(entry_request_status: Evaluation::NOT_YET_ASSESSED)

    redirect_to group_evaluation_path(current_evaluation.group, current_evaluation),
                notice: t(:submitted_entry_request)
  end

  def submit_point_request
    authorize_evaluation
    current_evaluation.update(point_request_status: Evaluation::NOT_YET_ASSESSED)

    redirect_to group_evaluation_path(current_evaluation.group, current_evaluation),
                notice: t(:submitted_point_request)
  end

  def cancel_entry_request
    authorize_evaluation

    current_evaluation.update(entry_request_status: Evaluation::NON_EXISTENT)

    redirect_to group_evaluation_path(current_evaluation.group, current_evaluation),
                notice: t(:cancelled_entry_request)
  end

  def cancel_point_request
    authorize_evaluation

    current_evaluation.update(point_request_status: Evaluation::NON_EXISTENT)

    redirect_to group_evaluation_path(current_evaluation.group, current_evaluation),
                notice: t(:cancelled_point_request)
  end

  private

  def authorize_evaluation
    authorize current_evaluation
  end

  def validate_correct_group
    forbidden_page unless current_evaluation.group == current_group
  end

  def new_evaluation
    evaluation = Evaluation.new(group_id:        current_group.id,
                                creator_user_id: current_user.id,
                                semester:        current_semester)
    evaluation.set_default_values
    evaluation.save!

    evaluation
  end
end
