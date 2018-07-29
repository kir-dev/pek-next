class PointDetail < ActiveRecord::Base
  self.primary_key = :id

  belongs_to :principle
  belongs_to :point_request

  before_save do
    self.point = valid_point
  end

  after_save do
    point_request.recalculate!
  end

  private

  def valid_point
    return 0 if point.nil? || point < 0
    max_point = principle.max_per_member
    return max_point if point > max_point
    point
  end
end
