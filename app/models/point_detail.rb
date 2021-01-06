# == Schema Information
#
# Table name: point_details
#
#  id               :integer          not null, primary key
#  point            :integer
#  point_request_id :integer
#  principle_id     :integer
#
# Indexes
#
#  index_point_details_on_principle_id_and_point_request_id  (principle_id,point_request_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (point_request_id => point_requests.id)
#  fk_rails_...  (principle_id => principles.id)
#

class PointDetail < ApplicationRecord
  belongs_to :principle
  belongs_to :point_request
  has_many :point_detail_comments, dependent: :destroy
  has_paper_trail

  validates :principle, presence: true
  validates :point_request, presence: true
  validates :principle_id, uniqueness: { scope: :point_request_id }
  validate :correct_evaluation

  before_save do
    self.point = valid_point
  end

  after_commit do
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
