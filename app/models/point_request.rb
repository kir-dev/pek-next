class PointRequest < ApplicationRecord
  self.table_name = 'pontigenyles'
  self.primary_key = :id

  alias_attribute :point, :pont
  alias_attribute :evaluation_id, :ertekeles_id
  alias_attribute :user_id, :usr_id

  belongs_to :evaluation, foreign_key: :ertekeles_id
  belongs_to :user, foreign_key: :usr_id
  has_many :point_details, inverse_of: :point_request

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
