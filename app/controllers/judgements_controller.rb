class JudgementsController < ApplicationController
  before_action :require_privileges_of_rvt

  def index
    @evaluations = Evaluation.where(date: current_semester).page(params[:page]).decorate
  end

  def show
    @evaluation = Evaluation.find(params[:evaluation_id])
    @point_details = PointDetail.includes(%i[point_request principle])
                                .select { |pd| pd.point_request.evaluation_id == @evaluation.id }
    @evaluation_messages =
      EvaluationMessage.where(group: @evaluation.group, semester: current_semester)
                       .order(sent_at: :desc).page(params[:page]).decorate
    @entry_requests = @evaluation.entry_requests.reject { |er| er.entry_type == EntryRequest::KDO }
    @entry_requests = EntryRequestDecorator.decorate_collection @entry_requests
  end

  def update
    unless SystemAttribute.evaluation_season?
      return redirect_back fallback_location: judgements_path, alert: t(:not_evaluation_season)
    end

    evaluation = Evaluation.find(params[:evaluation_id])
    create_judgement_service = CreateJudgement.new(judgement_params, evaluation)
    if create_judgement_service.call
      redirect_back fallback_location: judgements_path, notice: t(:edit_successful)
    else
      redirect_back fallback_location: judgements_path, alert: t(:no_changes)
    end
  end

  private

  def judgement_params
    params.permit(:entry_request_status, :point_request_status, :explanation)
  end
end
