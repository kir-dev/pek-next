class JudgementsController < ApplicationController

  def index
    authorize Evaluation.new, policy_class: JudgementPolicy
    @evaluations = Evaluation.where(date: current_semester).page(params[:page]).decorate
  end

  def show
    @evaluation = Evaluation.find(params[:evaluation_id])
    authorize @evaluation, policy_class: JudgementPolicy

    @point_details = PointDetail.includes(%i[point_request principle])
                                .select { |pd| pd.point_request.evaluation_id == @evaluation.id }
    @evaluation_messages =
      EvaluationMessage.where(group: @evaluation.group, semester: current_semester)
                       .order(sent_at: :desc).page(params[:page]).decorate
    @entry_requests = @evaluation.entry_requests.reject { |er| er.entry_type == EntryRequest::KDO }
    @entry_requests = EntryRequestDecorator.decorate_collection @entry_requests
    @users = @evaluation.point_requests
                        .includes(:user)
                        .map(&:user)
                        .sort_by(&:full_name)
    @users = UserDecorator.decorate_collection @users
  end

  def update
    evaluation = Evaluation.find(params[:evaluation_id])
    authorize evaluation, policy_class: JudgementPolicy

    authorize evaluation, :accept?, policy_class: JudgementPolicy if statuses.include?(Evaluation::ACCEPTED)
    authorize evaluation, :reject?, policy_class: JudgementPolicy if statuses.include?(Evaluation::REJECTED)

    create_judgement_service = CreateJudgement.new(judgement_params, evaluation)

    if create_judgement_service.call
      redirect_back fallback_location: judgements_path, notice: t(:edit_successful)
    else
      redirect_back fallback_location: judgements_path, alert: t(:no_changes)
    end
  end

  private

  def statuses
    [judgement_params[:point_request_status],judgement_params[:entry_request_status]]
  end

  def judgement_params
    params.permit(:entry_request_status, :point_request_status, :explanation)
  end
end
