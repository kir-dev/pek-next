class UserRole

  def initialize(user)
    @user = user
  end

  def pek_admin?
    @user.memberships.any? { |m| m.pek_admin? }
  end

  def svie_admin?
    @user.groups.any? { |g| g == Group.svie }
  end

  def rvt_member?
    @user.groups.any? { |g| g == Group.rvt }
  end

end
