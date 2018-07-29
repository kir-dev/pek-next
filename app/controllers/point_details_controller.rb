class PointDetailsController < ApplicationController
  before_action :require_login
  before_action :require_leader
  before_action :set_entities
  before_action :changeable_evaluation

  def update
    point_request = PointRequest.find_or_create_by(evaluation: @evaluation, user: @user)
    @point_detail = PointDetail.find_or_create_by(point_request: point_request,
                                                  principle: @principle)
    @point_detail.update(point: params[:point])

    @point_details = PointDetail.includes(%i[point_request principle]).select do |pd|
      pd.point_request.evaluation == @evaluation && pd.point_request.user_id == @user.id
    end
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
end
