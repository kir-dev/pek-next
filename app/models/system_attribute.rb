class SystemAttribute < ActiveRecord::Base
  self.table_name = "system_attrs"
  self.primary_key = :attributeid
  alias_attribute :value, :attributevalue
  alias_attribute :name, :attributename

  def self.semester
    Semester.new(find_by(name: "szemeszter").value)
  end

  def self.update_semester(semester)
    find_by(name: "szemeszter").update(value: semester)
  end

  def self.season
    find_by(name: 'ertekeles_idoszak')
  end

  def self.update_season(season)
    self.season.update(value: season)
    EntryRequest.remove_justifications unless application_season?
  end

  OFFSEASON = 'NINCSERTEKELES'
  APPLICATION_SEASON = 'ERTEKELESLEADAS'
  EVALUATION_SEASON = 'ERTEKELESELBIRALAS'

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
