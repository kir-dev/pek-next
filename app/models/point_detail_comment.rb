class PointDetailComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :point_detail

  validates :comment, presence: true, allow_blank: false
end
