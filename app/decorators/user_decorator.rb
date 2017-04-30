class UserDecorator < Draper::Decorator
  delegate_all
  include Draper::LazyHelpers

  def room
    return if user.dormitory.blank?
    room = [user.dormitory, user.room].join(' ')
    content_tag(:h4, room, class: 'uk-h4')
  end

  def cell_phone
    return if user.cell_phone.blank?
    content_tag(:h4, user.cell_phone, class: 'uk-h4')
  end

  def email
    return if user.email.blank?
    content_tag(:h4, user.email, class: 'uk-h4')
  end

  def nickname
    return if user.nickname.blank?
    ['-', user.nickname].join(' ')
  end

end
