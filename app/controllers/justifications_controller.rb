# This controller's actions are authenticated by the parent's policy. (EvaluationPolicy)
# WARNING: Renaming actions or implementing additional authentication could result unexpected behaviour!
class JustificationsController < EvaluationsController
  class EntryRequestsArentForTheSameGroup < StandardError; end
  before_action :validate_correct_group

  def edit
    evaluation = Evaluation.find(params[:evaluation_id])
    authorize evaluation, :edit_justification?

    @entry_requests = evaluation.entry_requests
                                .reject { |er| er.entry_type == EntryRequest::KDO }
                                .sort_by { |a| a.user.full_name }
                                .sort_by(&:entry_type)
    redirect_back fallback_location: root_url, alert: t(:no_entry_request) if @entry_requests.empty?
  end

  def update
    entry_requests = EntryRequest.find(params[:entry_requests].keys)
    evaluation = entry_requests.map(&:evaluation).uniq
    raise EntryRequestsArentForTheSameGroup unless evaluation.count == 1
    evaluation = evaluation.first
    authorize evaluation, :edit_justification?

    entry_requests.each do |entry_request|
      entry_request.update(params[:entry_requests][entry_request.id.to_s].permit(:justification))
    end

    redirect_to group_evaluations_current_path(current_group, params[:evaluation_id]),
                notice: t(:edit_successful)
  end
end
