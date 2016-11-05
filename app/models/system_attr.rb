class SystemAttr < ActiveRecord::Base
  self.primary_key = :attributeid
  alias_attribute :value, :attributevalue
  alias_attribute :name, :attributename

  def self.semester
    Semester.new(find_by(name: "szemeszter").value)
  end
end
