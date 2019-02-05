class PointDetailComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :point_detail

  delegate :principle, to: :point_detail

  validates :comment, presence: true, allow_blank: false
  validates :point_detail_id, presence: true, allow_blank: false
end
