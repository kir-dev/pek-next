class PointDetailCommentsController < ApplicationController
  def index
    comments = comments_by_principle_user_id(params[:principle_id].to_i, params[:user_id].to_i)
    @point_detail_comments = PointDetailCommentDecorator.decorate_collection(comments)
    @point_detail_comment = PointDetailComment.new
    render layout: false
  end

  def create
    create_comment = CreatePointDetailComment.new(params[:evaluation_id], params[:principle_id],
                                                  params[:user_id], current_user)
    @point_detail_comment = create_comment.call(params[:comment]).decorate
  end

  private

  def comments_by_principle_user_id(principle_id, user_id)
    PointDetailComment.includes([{ point_detail: [:point_request] }])
                      .order(:created_at)
                      .select do |comment|
      comment.point_detail.principle_id == principle_id &&
        comment.point_detail.point_request.user_id == user_id
    end
  end
end
