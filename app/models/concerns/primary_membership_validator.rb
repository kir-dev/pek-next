class PrimaryMembershipValidator < ActiveModel::Validator
  def validate(record)
    unless record.primary_membership.group.issvie
      record.errors.add(:primary_membership, 'egy nem-svie kör')
    end
    if record.primary_membership.newbie?
      record.errors.add(:primary_membership, 'még nem elfogadott tagság')
    end
  end
end
