class PointDetailsController < ApplicationController
  before_action :set_entities
  before_action :validate_correct_group

  def update
    authorize @evaluation, :update_point_request?
    @saved = true

    ActiveRecord::Base.transaction do
      begin
        point_detail_service          = CreateOrUpdatePointDetail.new(@user, @principle, @evaluation)
        @point_detail, @point_details = point_detail_service.call(params[:point])
      rescue StandardError => e
        @saved = false
        raise e
      end
    end

    unless @saved
      head(:unprocessable_entity)
    end
  end

  private

  def set_entities
    @user = User.find params[:user_id]
    @principle = Principle.find params[:principle_id]
    @evaluation = Evaluation.find params[:evaluation_id]
  end

  def validate_correct_group
    forbidden_page unless current_evaluation.group == current_group
  end
end
