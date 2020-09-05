# == Schema Information
#
# Table name: entry_requests
#
#  id            :bigint           not null, primary key
#  entry_type    :string(255)
#  justification :text
#  evaluation_id :bigint           not null
#  user_id       :bigint
#
# Indexes
#
#  bel_tipus_idx                                      (entry_type)
#  index_entry_requests_on_evaluation_id_and_user_id  (evaluation_id,user_id) UNIQUE
#
# Foreign Keys
#
#  fk4e301ac36958e716  (user_id => users.id)
#  fk_ertekeles_id     (evaluation_id => evaluations.id) ON DELETE => cascade
#

class EntryRequest < ApplicationRecord
  belongs_to :evaluation
  belongs_to :user

  validates :evaluation_id, uniqueness: { scope: :user_id }
  validate :correct_user

  AB = 'AB'.freeze
  KB = 'KB'.freeze
  KDO = 'KDO'.freeze
  DEFAULT_TYPE = KDO

  after_save do
    evaluation.update_last_change!
  end

  def self.remove_justifications
    where(entry_type: KDO).update_all(justification: '')
  end

  def accepted?
    evaluation.entry_request_accepted?
  end

  private

  def correct_user
    return if user.member_of?(evaluation.group)

    errors.add(:user, "user is not a member of the current group")
  end
end
