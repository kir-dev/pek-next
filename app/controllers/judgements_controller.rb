class JudgementsController < ApplicationController
  before_action :require_login
  before_action :require_privileges_of_rvt

  def index
    semester = SystemAttribute.semester.to_s
    @evaluations = Evaluation.where(date: semester).page(params[:page]).decorate
  end


  def edit
    @evaluation = Evaluation.find(params[:evaluation_id])
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
