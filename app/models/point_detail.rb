class PointDetail < ActiveRecord::Base
  self.primary_key = :id

  belongs_to :principle
  belongs_to :point_request

  after_save do
    point_request.recalculate!
  end
end
