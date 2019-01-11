class PointDetail < ActiveRecord::Base
  self.primary_key = :id

  belongs_to :principle
  belongs_to :point_request
  has_many :point_detail_comments, dependent: :destroy

  validates :principle, presence: true
  validates :point_request, presence: true
  validate :correct_evaluation

  before_save do
    self.point = valid_point
  end

  after_save do
    point_request.recalculate!
  end

  private

  def correct_evaluation
    return if principle&.evaluation == point_request&.evaluation

    errors.add(:principle, 'does not match point request evaluation')
  end

  def valid_point
    return 0 if point.nil? || point.negative?

    max_point = principle.max_per_member
    return max_point if point > max_point

    point
  end
end
