class CountDelegates
  def initialize
    @primary_users =
      User.primary_svie_members
          .includes(primary_membership: [:posts, :post_types, { user: [:primary_membership] }])
          .select { |user| user.primary_membership&.primary? }
  end

  def call
    reset_delegate_count
    count_delegates
  end

  private

  def reset_delegate_count
    Group.update_all grp_svie_delegate_nr: 0
  end

  def count_delegates
    group_member_count = Hash.new 0
    @primary_users.map { |user| user.primary_membership.group_id }
                  .each { |group_id| group_member_count[group_id] += 1 }
    group_member_count.each { |group_id, member_count| set_delegate_count(group_id, member_count) }
  end

  def set_delegate_count(group_id, member_count)
    return if member_count < 5

    group = Group.find(group_id)
    return unless group.issvie

    if member_count.between? 5, 20
      group.update delegate_count: 1
    else
      group.update delegate_count: member_count / 20
    end
  end
end
