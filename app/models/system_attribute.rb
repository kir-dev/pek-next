# == Schema Information
#
# Table name: system_attributes
#
#  id    :bigint           not null, primary key
#  name  :string(255)      not null
#  value :string(255)      not null
#

class SystemAttribute < ApplicationRecord
  has_paper_trail

  def self.semester
    Semester.new(find_by(name: 'szemeszter').value)
  end

  def self.update_semester(semester)
    find_by(name: 'szemeszter').update(value: semester)
  end

  def self.max_point_for_semester
    find_by(name: 'max_point_for_semester').value.to_i
  end

  def self.update_max_point_for_semester(point)
    find_by(name: 'max_point_for_semester').update(value: point)
  end

  def self.season
    find_by(name: 'ertekeles_idoszak')
  end

  def self.update_season(season)
    self.season.update(value: season)
    EntryRequest.remove_justifications unless application_season?
    return unless offseason?

    semester = SystemAttribute.semester
    calculate_point_history = CalculatePointHistory.new(semester)
    calculate_point_history.call
  end

  OFFSEASON = 'NINCSERTEKELES'.freeze
  APPLICATION_SEASON = 'ERTEKELESLEADAS'.freeze
  EVALUATION_SEASON = 'ERTEKELESELBIRALAS'.freeze

  def self.application_season?
    season.value == APPLICATION_SEASON
  end

  def self.evaluation_season?
    season.value == EVALUATION_SEASON
  end

  def self.offseason?
    season.value == OFFSEASON
  end
end
