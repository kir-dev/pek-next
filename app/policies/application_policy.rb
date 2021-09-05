class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def manage_SVIE?
    rvt_member? || rvt_helper?
  end

  private

  def pek_admin?
    cache { user.roles.pek_admin? }
  end

  def rvt_member?
    user.roles.rvt_member?
  end

  def rvt_helper?
    user.rvt_helper?
  end

  def off_season?
    cache { SystemAttribute.offseason? }
  end

  def application_season?
    cache { SystemAttribute.application_season? }
  end

  def evaluation_season?
    cache { SystemAttribute.evaluation_season? }
  end

  def cache
    variable_name = "@" + caller_locations(1, 1)[0].label.parameterize
    variable = instance_variable_get(variable_name)
    return variable unless variable.nil?

    instance_variable_set(variable_name, yield)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end
