class CreatePointDetailComment
  attr_reader :evaluation_id, :principle_id, :user_id, :sender

  def initialize(evaluation_id, principle_id, user_id, sender)
    @evaluation_id = evaluation_id.to_i
    @principle_id = principle_id.to_i
    @user_id = user_id.to_i
    @sender = sender
  end

  def call(comment)
    PointDetailComment.create(point_detail: point_detail, user: sender, comment: comment)
  end

  private

  def point_detail
    point_detail = PointDetail.includes(:point_request).find do |pd|
      pd.principle_id == principle_id && pd.point_request.user_id == user_id
    end
    return point_detail if point_detail

    member = User.find user_id
    principle = Principle.find principle_id
    evaluation = Evaluation.find evaluation_id
    point_detail_service = CreateOrUpdatePointDetail.new(member, principle, evaluation)
    point_detail, = point_detail_service.call(0)
    point_detail
  end
end
