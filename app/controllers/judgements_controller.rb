class JudgementsController < ApplicationController

  def index
    authorize Evaluation.new, policy_class: JudgementPolicy

    @evaluations = Evaluation.where(date: current_semester).includes(:group)
    if params[:resort_id].to_i == -1
      resortless_evaluation_ids = @evaluations.reject { |e| e.group.parent&.resort? || e.group.resort? }
                                              .map(&:id)
      @evaluations = @evaluations.where(id: resortless_evaluation_ids)
    elsif Group.exists?(params[:resort_id])
      @evaluations = @evaluations.where(group_id: groups_in_resort(params[:resort_id]).ids)
    end
    @evaluations = @evaluations.page(params[:page]).decorate

    @resorts = Group.resorts.order(:name)
  end

  def show
    @evaluation = Evaluation.includes(:principles).find(params[:evaluation_id])
    authorize @evaluation, policy_class: JudgementPolicy

    @point_details = PointDetail.includes(%i[point_request principle])
                                .select { |pd| pd.point_request.evaluation_id == @evaluation.id }
    @evaluation_messages =
      EvaluationMessage.where(group: @evaluation.group, semester: current_semester)
                       .order(sent_at: :desc).page(params[:page]).decorate
    @entry_requests = @evaluation.entry_requests.reject { |er| er.entry_type == EntryRequest::KDO }
    @entry_requests = EntryRequestDecorator.decorate_collection @entry_requests
    @users = User.joins(point_requests: :evaluation)
                 .where(evaluations: { id: params[:evaluation_id] })
                 .where.not(point_requests: { point: 0 })
                 .includes(:entry_requests, point_requests: [point_details: :principle])
                 .sort_by(&:full_name)
    @users = EvaluationUserDecorator.decorate_collection(@users, context: { evaluation: @evaluation })
    @evaluation_point_calculator = EvaluationPointCalculator.new(@users)
  end

  def update
    evaluation = Evaluation.find(params[:evaluation_id])
    authorize evaluation, policy_class: JudgementPolicy

    create_judgement_service = CreateJudgement.new(judgement_params, evaluation, current_user)
    begin
      create_judgement_service.call
    rescue CreateJudgement::NoChangeHaveBeenMade
      redirect_back fallback_location: judgements_path, alert: t(:no_changes)
      return
    rescue CreateJudgement::UserCantMakeTheRequestedUpdates
      raise Pundit::NotAuthorizedError
    end

    redirect_back fallback_location: judgements_path, notice: t(:edit_successful)
  end

  private

  def groups_in_resort(resort_id)
    Group.where(parent_id: resort_id).or(Group.where(id: resort_id))
  end

  def groups_outside_resorts
    Group.where(parent_id: resort_id).or(Group.where(id: resort_id))
  end

  def judgement_params
    params.permit(:entry_request_status, :point_request_status, :explanation)
  end
end
