class EvaluationMessageDecorator < Draper::Decorator
  delegate_all
  include Draper::LazyHelpers

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def sender_user_name
    return 'Rendszerüzenet' if sender_user.nil?
    sender_user.full_name
  end
end
