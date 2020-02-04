# == Schema Information
#
# Table name: point_requests
#
#  id            :bigint           not null, primary key
#  point         :integer
#  evaluation_id :bigint           not null
#  user_id       :bigint
#

class PointRequest < ApplicationRecord
  belongs_to :evaluation
  belongs_to :user
  has_many :point_details

  validates :user, presence: true
  validates :evaluation, presence: true
  validates :evaluation_id, uniqueness: { scope: :user_id }
  validate :correct_user

  def recalculate!
    self.point = ApplicationController.helpers.sum_all_details(point_details, user)
    save!
    evaluation.update_last_change!
  end

  def accepted?
    evaluation.accepted
  end

  private

  def correct_user
    return if user.member_of?(evaluation&.group)

    errors.add(:user, 'not member of evaluation group')
  end
end
