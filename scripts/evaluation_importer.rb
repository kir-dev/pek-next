class EvaluationImporter

  attr_reader :evaluation, :leader, :principle_data, :user_data,
              :point_data, :comment_data, :members, :not_members

  def initialize(evaluation:, principles:, users:, points:, comments:)
    @evaluation = evaluation
    @leader = evaluation.group.leader.user
    @principle_data = principles
    @user_data = users
    @point_data = points
    @comment_data = comments
    @members = evaluation.group.active_members.map(&:user)
    @not_members = []
  end

  def self.call(evaluation:, principles:, users:, points:, comments:)
    new(evaluation: evaluation, principles: principles, users: users, points: points, comments: comments).call
  end

  def call
    ActiveRecord::Base.transaction do
      principles = principle_data.map do |attributes|
        principle = Principle.new(attributes)
        principle.evaluation = evaluation
        principle.save!
        principle
      end
      user_data.each.with_index do |user_name, row|
        user = members.find { |member| member.full_name == user_name }
        not_members << user and next unless user
        point_request = PointRequest.create!(user: user, evaluation: evaluation)

        point_data[row].each.with_index do |point, col|
          next unless point
          principle = principles[col]
          pd = PointDetail.create!(point_request: point_request, principle: principle, point: point)
          comment = comment_data[row][col]
          PointDetailComment.create!(point_detail: pd, comment: comment, user: leader) if comment
        end
      end
    end
    evaluation.point_requests.reload.each(&:recalculate!)
  end
end
