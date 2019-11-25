class PointHistory < ApplicationRecord
  self.table_name = 'point_history'
  self.primary_key = :id

  belongs_to :user, foreign_key: :usr_id
end
