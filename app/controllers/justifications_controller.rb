class JustificationsController < ApplicationController
  before_action :require_login
  before_action :require_leader

  def edit
    @entry_requests = Evaluation.find(params[:evaluation_id]).entry_requests
      .select { |er| er.entry_type != EntryRequest::KDO }
  end

  def update
    entry_requests = EntryRequest.find(params[:entry_requests].keys)
    entry_requests.each do |entry_request|
      entry_request.update(params[:entry_requests][entry_request.id.to_s].permit(:justification))
    end
    redirect_to group_evaluations_current_path(current_group, params[:evaluation_id]), notice: t(:edit_successful)
  end

end
