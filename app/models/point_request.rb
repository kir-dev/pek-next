class PointRequest < ApplicationRecord
  belongs_to :evaluation
  belongs_to :user
  has_many :point_details

  validates :user, presence: true
  validates :evaluation, presence: true
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
