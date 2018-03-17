class UserRole

  def initialize(user)
    @user = user
  end

  def pek_admin?
    @user.memberships.any? { |m| m.pek_admin? }
  end

  def svie_admin?
    @user.member_of?(Group.svie)
  end

  def rvt_member?
    @user.member_of?(Group.rvt)
  end

end
