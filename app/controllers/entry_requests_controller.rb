class EntryRequestsController < ApplicationController
  before_action :require_leader

  def update
    user = User.find params[:user_id]
    evaluation = Evaluation.find params[:evaluation_id]
    entry_type = params[:entry_type]
    
    entry_request = EntryRequest.find_or_create_by(evaluation: evaluation, user: user)
    entry_request.update(entry_type: entry_type)

    head :ok
  end
end
