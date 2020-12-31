# == Schema Information
#
# Table name: point_detail_comments
#
#  id              :integer          not null, primary key
#  closing         :boolean
#  comment         :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  point_detail_id :integer
#  user_id         :integer
#
# Indexes
#
#  index_point_detail_comments_on_point_detail_id  (point_detail_id)
#  index_point_detail_comments_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (point_detail_id => point_details.id)
#  fk_rails_...  (user_id => users.id)
#

class PointDetailComment < ApplicationRecord
  belongs_to :user
  belongs_to :point_detail

  delegate :principle, to: :point_detail

  validates :comment, presence: true, allow_blank: false
  validates :point_detail_id, presence: true, allow_blank: false
end
