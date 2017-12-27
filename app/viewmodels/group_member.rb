class GroupMember

  def initialize(membership)
    @membership = membership
  end

  def posts
    return 'öregtag' unless @membership.end.nil? || @membership.archived
    return 'archivált' if @membership.end && @membership.archived
    return 'tag' if @membership.post_types.empty?
    @membership.post_types.map(&:pttip_name).join(', ')
  end

  def full_name
    @membership.user.full_name
  end

  def nickname
    @membership.user.nickname
  end

  def screen_name
    @membership.user.screen_name
  end

  def membership_start
    @membership.start
  end

  def membership_end
    @membership.end
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

  def membership_timer
    if @membership.end
      [@membership.start, @membership.end].join(' - ')
    else
      "#{@membership.start} -"
    end
  end

end
