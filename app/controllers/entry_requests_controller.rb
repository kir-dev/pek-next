class EntryRequestsController < ApplicationController
  before_action :set_evaluation, only: [:update]

  def update
    authorize @evaluation, :update_entry_request?
    begin
      ActiveRecord::Base.transaction do
        create_or_update_entry_request
      end
    rescue ActiveRecord::RecordNotUnique, ActiveRecord::StatementInvalid
      retry
    end

    head :ok
  rescue ActiveRecord::RecordInvalid, RecordNotFound
    head :unprocessable_entity
  end

  def update_review
    head :ok
  end

  def review
    authorize :entry_request, :review?
    @resorts = Group.where(id: Group::RESORTS).order(:name)
    @entry_requests = EntryRequest.joins(:evaluation).includes(:group, :user).where('evaluations.semester': SystemAttribute.semester.to_s)
                                  .where("entry_requests.entry_type != 'KDO' OR entry_requests.justification != NULL")
  end

  private

  def create_or_update_entry_request
    user       = User.find(params[:user_id])
    entry_type = params[:entry_type]

    entry_request = EntryRequest.find_or_create_by!(evaluation: @evaluation, user: user)
    entry_request.update!(entry_type: entry_type)
  end

  def set_evaluation
    @evaluation = Evaluation.find(params[:evaluation_id])
  end
end
