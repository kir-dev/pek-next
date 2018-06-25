class EntryRequestDecorator < Draper::Decorator
  delegate_all
  include Draper::LazyHelpers

  def nice_entry_type
    Rails.configuration.x.entry_types[entry_type]
  end
end
