class PrincipleDecorator < Draper::Decorator
  delegate_all
  include Draper::LazyHelpers

  def nice_type
    Rails.configuration.x.principle_types[type]
  end
end
