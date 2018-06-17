class EvaluationsController < ApplicationController
  before_action :require_login
  before_action :require_leader
  before_action :validate_correct_group, only: [:show, :edit, :update, :table]
  before_action :validate_correct_leader, only: [:submit_entry_request, :submit_point_request]

  def current
    evaluation = Evaluation.find_by({ group_id: current_group.id, semester: SystemAttribute.semester.to_s })
    unless evaluation
      evaluation = Evaluation.create({
        group_id: current_group.id,
        creator_user_id: current_user.id,
        semester: SystemAttribute.semester.to_s
        })
    end
    redirect_to group_evaluation_path(evaluation.group, evaluation)
  end

  def show
    @evaluation = Evaluation.find(params[:id])
  end

  def edit
    @evaluation = Evaluation.find_by({ group_id: current_group.id, semester: SystemAttribute.semester.to_s })
  end

  def update
    evaluation = Evaluation.find(params[:id])
    evaluation.update(params.require(:evaluation).permit(:justification))
    redirect_to group_evaluation_path(evaluation.group, evaluation), notice: t(:edit_successful)
  end

  def table
    @evaluation = Evaluation.find(params[:evaluation_id])
    @point_details = PointDetail.includes(:point_request).select { |pd| pd.point_request.evaluation == @evaluation }
  end

  def submit_entry_request
    evaluation = Evaluation.find(params[:evaluation_id])
    evaluation.update(entry_request_status: Evaluation::NOT_YET_ASSESSED)

    redirect_to group_evaluation_path(evaluation.group, evaluation), notice: t(:submitted_entry_request)
  end

  def submit_point_request
    evaluation = Evaluation.find(params[:evaluation_id])
    evaluation.update(point_request_status: Evaluation::NOT_YET_ASSESSED)

    redirect_to group_evaluation_path(evaluation.group, evaluation), notice: t(:submitted_point_request)
  end

  private

  def validate_correct_group
    evaluation = Evaluation.find(params[:evaluation_id] || params[:id])
    unauthorized_page unless evaluation.group == current_group
  end

  def validate_correct_leader
    redirect_to root_url unless current_user.leader_of? Group.find(params[:group_id])
  end
end
