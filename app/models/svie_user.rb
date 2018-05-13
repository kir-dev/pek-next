class SvieUser
  NOT_MEMBER = 'NEMTAG'.freeze
  INSIDE_MEMBER = 'BELSOSTAG'.freeze
  OUTSIDE_MEMBER = 'KULSOSTAG'.freeze
  INACTIVE_MEMBER = 'OREGTAG'.freeze

  def initialize(user)
    @user = user
  end

  def can_join?
    !member? && !in_processing?
  end

  def member?
    @user.svie_member_type != NOT_MEMBER
  end

  def in_processing?
    !@user.svie_post_request.nil?
  end

  def inside_member?
    @user.svie_member_type == INSIDE_MEMBER
  end

  def outside_member?
    @user.svie_member_type == OUTSIDE_MEMBER
  end

  def inactive_member?
    @user.svie_member_type == INACTIVE_MEMBER
  end

  def can_join_to?(member_type)
    return false if(self.in_processing?) || @user.svie_member_type == member_type
    return !inside_member? if(member_type == OUTSIDE_MEMBER)
    true
  end

  def create_request(member_type)
    SviePostRequest.create(user: @user, member_type: member_type)
  end

  def try_inactivate!
    if @user.groups.select {|g| g.issvie?}.nil?
      @user.update(svie_member_type: INACTIVE_MEMBER, primary_membership: nil)
    end
  end
end
