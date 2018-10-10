class CountDelegates
  def initialize(groups)
    @groups = groups
    @groups ||= Group.select(&:issvie)
  end

  def call
    @groups.each { |group| count_delegates_for_group(group) }
  end

  private

  def count_delegates_for_group(group)
    return if group.delegate_count&.zero?
    primary_member_count = group.memberships.select(&:primary?).count
    if primary_member_count.between? 5, 20
      group.update delegate_count: 1
    else
      group.update delegate_count: primary_member_count / 20
    end
  end
end
