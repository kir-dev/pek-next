class EvaluationDecorator < Draper::Decorator
  delegate_all
  include Draper::LazyHelpers
  decorates_finders

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def nice_point_request_status
    Rails.configuration.x.evaulation_request_statuses[point_request_status]
  end

  def nice_entry_request_status
    Rails.configuration.x.evaulation_request_statuses[entry_request_status]
  end
end
