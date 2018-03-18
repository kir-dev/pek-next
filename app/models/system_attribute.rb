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

  def application_season?
    self.value == 'ERTEKELESELBIRALAS'
  end

end
