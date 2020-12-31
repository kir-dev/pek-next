module PointDetailCommentHelper
  def comments_status(point_detail)
    return "" unless point_detail&.point_detail_comments&.present?
    return "has-comment has-comment-closing" if point_detail.point_detail_comments.order(:created_at).last.closing

    "has-comment"
  end
end