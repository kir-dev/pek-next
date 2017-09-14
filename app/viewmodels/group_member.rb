class GroupMember

  def initialize(membership)
    @membership = membership
  end

  def posts
    if @membership.post_types.empty?
      return 'Tag'
    end
    
    @membership.post_types.map(&:pttip_name).join(', ')
    
  end

  def full_name
    @membership.user.full_name
  end

  def nickname
    @membership.user.nickname
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

end
