class PointDetailsController < ApplicationController
  before_action :require_resort_or_group_leader
  before_action :require_application_season_for_group_leader
  before_action :set_entities
  before_action :changeable_evaluation
  before_action :validate_correct_group

  def update
    point_detail_service = CreateOrUpdatePointDetail.new(@user, @principle, @evaluation)
    @point_detail, @point_details = point_detail_service.call(params[:point])
  rescue ActiveRecord::RecordInvalid
    head(:unprocessable_entity)
  end

  private

  def set_entities
    @user = User.find params[:user_id]
    @principle = Principle.find params[:principle_id]
    @evaluation = Evaluation.find params[:evaluation_id]
  end

  def changeable_evaluation
    redirect_to root_url unless @evaluation.changeable_point_request_status?
  end

  def validate_correct_group
    forbidden_page unless current_evaluation.group == current_group
  end
end
