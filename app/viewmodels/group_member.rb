class GroupMember
  attr_reader :membership

  def initialize(membership)
    @membership = membership
  end

  def posts
    return 'öregtag' unless @membership.end_date.nil? || @membership.archived
    return 'archivált' if @membership.end_date && @membership.archived
    return 'tag' if @membership.post_types.empty?

    @membership.post_types.map(&:pttip_name).join(', ')
  end

  def full_name
    @membership.user.full_name
  end

  def nickname
    @membership.user.nickname
  end

  def compact_name
    return full_name if nickname.blank?

    "#{full_name} (#{nickname})"
  end

  def screen_name
    @membership.user.screen_name
  end

  def membership_start
    @membership.start_date
  end

  def membership_end
    @membership.end_date
  end

  def membership_id
    @membership.id
  end

  def group_id
    @membership.group.id
  end

  def group_name
    @membership.group.name
  end

  def primary_member?
    @membership == @membership.user.primary_membership
  end

  def user
    @membership.user
  end

  def membership_timer
    return "#{@membership.start_date} - #{@membership.end_date}" if @membership.end_date

    "#{@membership.start_date} -"
  end
end
