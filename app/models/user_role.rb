class UserRole
  SVIE_GROUP_ID = 369

  def initialize(user)
    @user = user
  end

  def svie_admin?
    @user.groups.any? { |g| g.id == SVIE_GROUP_ID }
  end
end
