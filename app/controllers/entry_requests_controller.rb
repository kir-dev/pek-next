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

  def review
    authorize :entry_request, :review?
    @rvt_leader = current_user.roles.rvt_leader?
    @resorts = Group.where(id: Group::RESORTS).order(:name)
    @entry_requests = EntryRequest.joins(:evaluation).includes(:group, :user).where('evaluations.semester': SystemAttribute.semester.to_s)
                                  .where("entry_requests.entry_type != 'KDO' OR entry_requests.justification != NULL")
    if params[:unfinalized] == '1'
      @entry_requests = @entry_requests.where(finalized: false)
    end
    @order = params[:order] || 'id'
    @entry_requests = @entry_requests.order(@order)
  end

  def update_review
    authorize :entry_request, :update_review?

    entry_request = EntryRequest.find(params[:id])
    if current_user.roles.rvt_leader?
      entry_request.assign_attributes(entry_request_params)
    end
    resorts = Group.resorts
    group_ids_where_the_user_the_leader = Membership.joins(:posts)
                                                    .where(user: current_user,
                                                           'posts.post_type_id': PostType::LEADER_POST_ID)
                                                    .pluck(:group_id)
    resorts.each do |resort|
      recommendation = params[:recommendations].find { |recommendation| recommendation["resort_id"].to_i == resort.id }
      if group_ids_where_the_user_the_leader.include?(resort.id)
        entry_request.recommendations[resort.id.to_s] = recommendation['value']
      end
    end
    entry_request.save! if entry_request.changed?

    head :ok
  end

  private

  def entry_request_params
    params.require(:entry_request).permit(:entry_type, :justification, :finalized)
  end

  def create_or_update_entry_request
    user = User.find(params[:user_id])
    entry_type = params[:entry_type]

    entry_request = EntryRequest.find_or_create_by!(evaluation: @evaluation, user: user)
    entry_request.update!(entry_type: entry_type)
  end

  def set_evaluation
    @evaluation = Evaluation.find(params[:evaluation_id])
  end
end
