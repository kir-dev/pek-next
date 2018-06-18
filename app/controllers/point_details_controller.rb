class PointDetailsController < ApplicationController
  before_action :require_login
  before_action :require_leader
  before_action :changeable_evaluation

  def update
    @user = User.find params[:user_id]
    principle = Principle.find params[:principle_id]
    point = params[:point].to_i

    point_request = PointRequest.find_or_create_by(evaluation: @evaluation, user: @user)
    point_detail = PointDetail.find_or_create_by(point_request: point_request, principle: principle)
    point_detail.update(point: point)

    @point_details = PointDetail.includes([ :point_request, :principle ]).select {
      |pd| pd.point_request.evaluation == @evaluation && pd.point_request.user_id == @user.id }
  end

  private

  def changeable_evaluation
    @evaluation = Evaluation.find params[:evaluation_id]

    redirect_to root_url unless @evaluation.changeable_point_request_status?
  end
end
