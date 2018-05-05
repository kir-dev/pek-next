class PointDetailsController < ApplicationController
  before_action :require_login
  before_action :require_leader

  def update
    user = User.find params[:user_id]
    principle = Principle.find params[:principle_id]
    evaluation = Evaluation.find params[:evaluation_id]
    point = params[:point].to_i
    
    point_request = PointRequest.find_or_create_by(evaluation: evaluation, user: user)
    point_detail = PointDetail.find_or_create_by(point_request: point_request, principle: principle)
    point_detail.update(point: point)
  end
end
