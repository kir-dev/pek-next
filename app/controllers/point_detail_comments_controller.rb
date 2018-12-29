class PointDetailCommentsController < ApplicationController
  def index
    @point_detail_comments =
      PointDetailComment.includes([{ point_detail: [:point_request] }])
                        .order(:created_at)
                        .select do |comment|
        comment.point_detail.principle_id == params[:principle_id].to_i &&
          comment.point_detail.point_request.user_id == params[:user_id].to_i
      end
    @point_detail_comment = PointDetailComment.new
    render layout: false
  end

  def create
    create_comment = CreatePointDetailComment.new(params[:evaluation_id], params[:principle_id],
                                                  params[:user_id], current_user)
    @point_detail_comment = create_comment.call(params[:comment])
  end
end
