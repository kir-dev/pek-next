class PointDetailCommentsController < ApplicationController
  before_action :set_point_detail_comment, only: %i[edit update destroy]
  before_action :authorize_comment

  def index
    comments = comments_by_principle_user_id(params[:principle_id].to_i, params[:user_id].to_i)
    @user = User.find(params[:user_id])
    @principle = Principle.find(params[:principle_id])
    @point_detail_comments = PointDetailCommentDecorator.decorate_collection(comments)
    @point_detail_comment = PointDetailComment.new
    render layout: false
  end

  def create
    create_comment = CreatePointDetailComment.new(params[:evaluation_id], params[:principle_id],
                                                  params[:user_id], current_user)
    closing = update_params[:closing]
    closing = false unless current_user.roles.rvt_member?

    point_detail_comment = create_comment.call(update_params[:comment], closing)
    return head :forbidden unless point_detail_comment&.valid?

    @point_detail_comment = point_detail_comment.decorate
  end

  def update
    return unless @point_detail_comment.user == current_user

    @point_detail_comment.update update_params
    respond_to do |format|
      format.html { redirect_back fallback_location: root_url }
      format.js
    end
  end

  def edit; end

  def destroy
    return unless @point_detail_comment.user == current_user

    @point_detail_comment.destroy!
    respond_to do |format|
      format.html { redirect_back fallback_location: root_url }
      format.js
    end
  end

  private

  def set_point_detail_comment
    @point_detail_comment = PointDetailComment.find(params[:id]).decorate
  end

  def update_params
    params.require(:point_detail_comment).permit(:comment, :closing)
  end

  def comments_by_principle_user_id(principle_id, user_id)
    PointDetailComment.includes([{ point_detail: [:point_request] }])
                      .order(:created_at)
                      .where('point_details.principle_id': principle_id, 'point_requests.user_id': user_id)
  end

  def authorize_comment
    principle = @point_detail_comment&.principle
    principle ||= Principle.find params[:principle_id]

    @evaluation = principle.evaluation
    unless PointDetailPolicy.new(current_user, @evaluation, principle).update_comments?
      raise NotAuthorizedError
    end
  end
end
