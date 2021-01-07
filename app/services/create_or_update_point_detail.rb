class CreateOrUpdatePointDetail
  attr_reader :user, :principle, :evaluation

  def initialize(user, principle, evaluation)
    @user = user
    @principle = principle
    @evaluation = evaluation
  end

  def call(point)
    ActiveRecord::Base.transaction do
      point_request = PointRequest.find_or_create_by!(evaluation_id: evaluation.id, user_id: user.id)

      point_detail = PointDetail.find_or_create_by!(point_request_id: point_request.id,
                                                    principle_id: principle.id)
      point_detail.update!(point: point)

      point_details = PointDetail.includes(%i[point_request principle]).select do |pd|
        pd.point_request.evaluation_id == evaluation.id && pd.point_request.user_id == user.id
      end

      [point_detail, point_details]
    end
  end
end
