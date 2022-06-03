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
    @evaluation = current_evaluation
    authorize(@evaluation, :show?)
    @can_edit = policy(@evaluation).edit?
  end

  def update
    authorize_evaluation

    current_evaluation.update(params.require(:evaluation).permit(:justification))
    redirect_to group_evaluation_path(current_evaluation.group, current_evaluation),
                notice: t(:edit_successful)
  end

  def table
    authorize_evaluation

    @point_details = PointDetail.joins(point_request: :evaluation)
                                .where(evaluations: { id: current_evaluation.id })
                                .includes(:principle)
    @evaluation = current_evaluation
    @ordered_principles = @evaluation.principles.order(:type, :id)

    point_eligible_user_ids = @evaluation.group.point_eligible_memberships.map(&:user_id)
    @users = User.where(id: point_eligible_user_ids)
                 .includes(:entry_requests,
                           point_requests: [point_details: [:point_detail_comments, :principle]])
    @users = EvaluationUserDecorator.decorate_collection(@users, context: { evaluation: @evaluation })
    @users = @users.sort { |a, b| hu_compare(a.full_name, b.full_name) }

    @evaluation_point_calculator = EvaluationPointCalculator.new(@users)
    evaluation_policy = policy(@evaluation)
    @update_point_request = evaluation_policy.update_point_request?
    @update_entry_request = evaluation_policy.update_entry_request?
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

  def copy_previous_principles
    authorize_evaluation

    previous_evaluation = current_group.evaluations.second_to_last
    ActiveRecord::Base.transaction do
      previous_evaluation.principles.find_each do |principle|
        Principle.create!(evaluation: current_evaluation,
                          name: principle.name,
                          description: principle.description,
                          type: principle.type,
                          max_per_member: principle.max_per_member)
      end
    end
    flash[:notice] = t('evaluation.successful_principle_import')
    redirect_to group_evaluation_principles_path(current_group, current_evaluation)
  end

  private

  def authorize_evaluation
    authorize current_evaluation
  end

  def validate_correct_group
    forbidden_page unless current_evaluation.group == current_group
  end

  def new_evaluation
    evaluation = Evaluation.new(group_id: current_group.id,
                                creator_user_id: current_user.id,
                                semester: current_semester)
    evaluation.set_default_values
    evaluation.save!

    evaluation
  end
end
