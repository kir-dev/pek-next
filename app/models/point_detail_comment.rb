# == Schema Information
#
# Table name: point_detail_comments
#
#  id              :integer          not null, primary key
#  comment         :text
#  user_id         :integer
#  point_detail_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class PointDetailComment < ApplicationRecord
  belongs_to :user
  belongs_to :point_detail

  delegate :principle, to: :point_detail

  validates :comment, presence: true, allow_blank: false
  validates :point_detail_id, presence: true, allow_blank: false
end
