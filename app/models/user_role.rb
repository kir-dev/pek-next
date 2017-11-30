class UserRole
  SVIE_GROUP_ID = 369
  RVT_GROUP_ID = 146

  def initialize(user)
    @user = user
  end

  def svie_admin?
    @user.groups.any? { |g| g.id == SVIE_GROUP_ID }
  end

  def rvt_member?
    @user.groups.any? { |g| g.id == RVT_GROUP_ID }
  end
end
