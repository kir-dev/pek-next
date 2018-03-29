class SvieUser
  def initialize(user)
    @user = user
  end

  def need_join?
    !member? && !in_processing?
  end

  def member?
    @user.svie_member_type != 'NEMTAG'
  end

  def in_processing?
    @user.svie_post_request
  end

  def inside_member?
    @user.svie_member_type == 'BELSOSTAG'
  end

  def outside_member?
    @user.svie_member_type == 'KULSOSTAG'
  end

  def inactive_member?
    @user.svie_member_type == 'OREGTAG'
  end

  def remove_membership!
    @user.svie_member_type = 'NEMTAG'
    @user.save!
  end

  def can_join?(into)
    return false if(self.in_processing?) || @user.svie_member_type == into
    return !inside_member? if(into == 'KULSOSTAG')
    true
  end

  def createRequest(into)
    unless self.can_join?(into)
      abort('Nope')
    end
    SviePostRequest.create(usr_id: @user.id, member_type: into)
  end
end
