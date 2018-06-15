class JudgementController < ApplicationController
  before_action :require_login
  before_action :require_privileges_of_rvt

  def index
    semester = SystemAttribute.semester.to_s
    @evaluations = Evaluation.where(date: semester).page(params[:page]).decorate
  end

  def show
    @evaluation = Evaluation.find(params[:evaluation_id])
    @point_details = PointDetail.includes(:point_request)
      .select { |pd| pd.point_request.evaluation == @evaluation }
    @entry_requests = EntryRequestDecorator.decorate_collection(@evaluation
      .entry_requests.select { |er| er.entry_type != EntryRequest::KDO })
  end

  def update
    unless SystemAttribute.evaluation_season?
      return redirect_back fallback_location: judgements_path, alert: t(:not_evaluation_season)
    end
    evaluation = Evaluation.find(params[:evaluation_id])
    success = CreateJudgement.call(evaluation, judgement_params)
    if success
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
