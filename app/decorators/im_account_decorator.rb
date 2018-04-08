class ImAccountDecorator < Draper::Decorator
  delegate_all
  include Draper::LazyHelpers

  def account
    full_name = [ImAccount.human_attribute_name('protocol.' + protocol), account_name].join(': ')
    content_tag(:h5, full_name, class: 'uk-h5')
  end

end
