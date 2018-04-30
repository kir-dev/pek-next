class SvieUser
  def initialize(user)
    @user = user
  end
  
  def not_member?
    @user.svie_state == 'NEMTAG'
  end

  def member?
    @user.svie_state == 'ELFOGADVA'
  end

  def in_processing?
    @user.svie_state == 'FELDOLGOZASALATT'
  end

  def inside_member?
    @user.svie_member_type == 'RENDESTAG'
  end

  def outside_member?
    @user.svie_member_type == 'PARTOLOTAG'
  end

  def inactive_member?
    @user.svie_member_type == 'OREGTAG'
  end

  def remove_membership!
    @user.svie_state = 'NEMTAG'
    @user.svie_member_type = 'NEMTAG'
    @user.save!
  end
end
