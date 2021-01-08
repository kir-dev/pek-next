class EntryRequestsController < ApplicationController
  before_action :set_evaluation

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
