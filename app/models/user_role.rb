class UserRole
  def initialize(user)
    @user = user
  end

  def pek_admin?
    @user.membership_for(Group.kirdev)&.has_post?(PostType::PEK_ADMIN_ID)
  end

  def svie_admin?
    @user.member_of?(Group.svie) || rvt_leader? || pek_admin?
  end

  def rvt_member?
    @user.member_of?(Group.rvt) || pek_admin?
  end

  def rvt_leader?
    @user.leader_of?(Group.rvt) || pek_admin?
  end

  def resort_leader?(group)
    @user.leader_of?(group.parent) || pek_admin?
  end
end
