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
    return true if SystemAttribute.evaluation_season? && request_status == REJECTED
    return true if SystemAttribute.application_season? &&
                   ([NON_EXISTENT, REJECTED].include? request_status)

    false
  end
end
