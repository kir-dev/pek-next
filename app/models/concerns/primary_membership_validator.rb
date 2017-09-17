class PrimaryMembershipValidator < ActiveModel::Validator
  def validate(record)
    return unless record.svie_primary_membership
    unless record.primary_membership.group.issvie
      record.errors.add(:svie_primary_membership, 'egy nem-svie kör')
    end
    if record.primary_membership.newbie?
      record.errors.add(:svie_primary_membership, 'még nem elfogadott tagság')
    end
  end
end
