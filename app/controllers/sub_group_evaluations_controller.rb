class SubGroupEvaluationsController < ApplicationController
  include EvaluationsControllerHelper
  before_action :set_search, only: :table
  before_action :require_sssl
  def table
    @sub_group = SubGroup.find(params[:sub_group_id])
    authorize @sub_group, policy_class: SubGroupEvaluationPolicy
    @point_details = PointDetail.joins(point_request: :evaluation)
                                .where(evaluations: { id: current_evaluation.id })
                                .includes(:principle)
    @evaluation = current_evaluation
    @group = @evaluation.group

    @ordered_principles = @evaluation.principles
                                     .where(sub_group_id: params[:sub_group_id])
                                     .order(:type, :id)
    filter_principles
    point_eligible_user_ids = @evaluation.group.point_eligible_memberships.map(&:user_id)
    @users = User.with_full_name.where(id: point_eligible_user_ids)
                 .includes(:entry_requests,
                           point_requests: [point_details: [:point_detail_comments, :principle]])
    filter_users
    search_users
    @users = @users.joins(:sub_groups).where(sub_groups: {id: params[:sub_group_id]})
    @users = @users.order(:full_name).page(params[:page])
    @users_for_pagination = @users
    @users = EvaluationUserDecorator.decorate_collection(@users, context: { evaluation: @evaluation })

    @evaluation_point_calculator = EvaluationPointCalculator.new(@users)
    evaluation_policy =  SubGroupEvaluationPolicy.new(current_user, @sub_group)
    @update_point_request = evaluation_policy.update_point_request?
    @update_entry_request = evaluation_policy.update_entry_request?

    render 'evaluations/table'
  end
end
