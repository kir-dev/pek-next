class ImAccountDecorator < Draper::Decorator
  delegate_all
  include Draper::LazyHelpers

  def account
    humanized_protocol = ImAccount.human_attribute_name("protocol.#{protocol}")
    content_tag(:h5, "#{humanized_protocol}: #{account_name}", class: 'uk-h5')
  end
end
