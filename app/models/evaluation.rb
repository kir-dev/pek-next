# == Schema Information
#
# Table name: evaluations
#
#  id                   :bigint           not null, primary key
#  entry_request_status :string(255)
#  explanation          :text
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
#  ert_semester_idx  (semester)
#  next_version_idx  (next_version)
#  unique_idx        (group_id,semester,next_version) UNIQUE
#
# Foreign Keys
#
#  fk807db18871c0d156  (creator_user_id => users.id)
#  fk807db18879696582  (group_id => groups.id)
#  fk807db188b31cf015  (reviewer_user_id => users.id)
#  fk_next_version     (next_version => evaluations.id) ON DELETE => nullify
#

class Evaluation < ApplicationRecord
  before_save :set_default_values

  alias_attribute :date, :semester

  belongs_to :group
  has_many :point_requests
  has_many :entry_requests
  has_many :principles
  has_many :ordered_principles, -> { order(:id) }, class_name: :Principle

  NON_EXISTENT = 'NINCS'.freeze
  ACCEPTED = 'ELFOGADVA'.freeze
  REJECTED = 'ELUTASITVA'.freeze
  NOT_YET_ASSESSED = 'ELBIRALATLAN'.freeze

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

  def changeable_entry_request_status?
    can_change_request_status_of? entry_request_status
  end

  def changeable_point_request_status?
    can_change_request_status_of? point_request_status
  end

  private

  def can_change_request_status_of?(request_status)
    SystemAttribute.evaluation_season? && request_status == REJECTED ||
      SystemAttribute.application_season? && request_status != ACCEPTED
  end
end
