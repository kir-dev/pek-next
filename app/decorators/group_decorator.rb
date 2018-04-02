class GroupDecorator < Draper::Decorator
  delegate_all
  include Draper::LazyHelpers

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def formatted_description
    return unless group.description
    simple_format(format_description)
  end

  def truncated_description
    return unless group.description
    simple_format(truncate(format_description, length: 100))
  end

  private
    def format_description
      group.description.gsub('[-----------------------------------------]','<br/>')
    end

end
