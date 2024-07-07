# == Schema Information
#
# Table name: evaluations
#
#  id                   :bigint           not null, primary key
#  entry_request_status :string(255)
#  explanation          :text
#  idx_in_semester      :integer          default(0), not null
#  is_considered        :boolean          default(FALSE), not null
#  justification        :text             not null
#  last_evaulation      :datetime
#  last_modification    :datetime
#  next_version         :bigint
#  optlock              :integer          default(0), not null
#  point_request_status :string(255)
#  principle            :text             default(""), not null
#  semester             :string(9)        not null
#  timestamp            :datetime
#  creator_user_id      :bigint
#  group_id             :bigint
#  reviewer_user_id     :bigint
#
# Indexes
#
#  ert_semester_idx                                                (semester)
#  index_evaluations_on_group_id_and_semester_and_idx_in_semester  (group_id,semester,idx_in_semester) UNIQUE
#  next_version_idx                                                (next_version)
#  unique_idx                                                      (group_id,semester,next_version NULLS FIRST) UNIQUE
#
# Foreign Keys
#
#  fk807db18871c0d156  (creator_user_id => users.id)
#  fk807db18879696582  (group_id => groups.id)
#  fk807db188b31cf015  (reviewer_user_id => users.id)
#  fk_next_version     (next_version => evaluations.id) ON DELETE => nullify
#

class Evaluation < ApplicationRecord
  alias_attribute :date, :semester
  has_paper_trail skip: [:last_modification]

  belongs_to :group
  has_many :point_requests
  has_many :entry_requests
  has_many :principles
  has_many :ordered_principles, -> { order(:id) }, class_name: :Principle

  NON_EXISTENT = 'NINCS'.freeze
  ACCEPTED = 'ELFOGADVA'.freeze
  REJECTED = 'ELUTASITVA'.freeze
  NOT_YET_ASSESSED = 'ELBIRALATLAN'.freeze
  EVALUATION_STATUSES = [NON_EXISTENT, ACCEPTED, REJECTED, NOT_YET_ASSESSED].freeze

  validates :point_request_status, inclusion: { in:      EVALUATION_STATUSES,
                                                message: "%{value} is not a valid EVALUATION_STATUS" }
  validates :entry_request_status, inclusion: { in:      EVALUATION_STATUSES,
                                                message: "%{value} is not a valid EVALUATION_STATUS" }

  include Notifications::EvaluationNotifier

  def point_request_accepted?
    point_request_status == ACCEPTED
  end

  def entry_request_accepted?
    entry_request_status == ACCEPTED
  end

  def no_entry_request?
    entry_request_status == NON_EXISTENT
  end

  def accepted
    point_request_accepted? && !next_version
  end

  def date_as_semester
    Semester.new(date)
  end

  def set_default_values
    self.point_request_status ||= NON_EXISTENT
    self.entry_request_status ||= NON_EXISTENT
    self.timestamp ||= Time.now
    self.justification ||= ''
    self.last_modification = Time.now
    self
  end

  def update_last_change!
    self.last_modification = Time.now
    save!
  end
end
