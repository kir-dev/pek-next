class PrimaryMembershipValidator < ActiveModel::Validator
  def validate(record)
    return unless record.svie_primary_membership
    return if record.primary_membership.group.issvie

    record.errors.add(:svie_primary_membership, 'egy nem-svie kör')
  end
end
