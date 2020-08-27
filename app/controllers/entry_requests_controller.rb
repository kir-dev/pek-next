class EntryRequestsController < ApplicationController
  before_action :require_resort_or_group_leader
  before_action :require_application_or_evaluation_season
  before_action :require_application_season_for_group_leader

  def update
    user = User.find params[:user_id]
    evaluation = Evaluation.find params[:evaluation_id]
    entry_type = params[:entry_type]

    entry_request = EntryRequest.find_or_create_by(evaluation: evaluation, user: user)
    entry_request.update(entry_type: entry_type)

    head :ok
  end
end
