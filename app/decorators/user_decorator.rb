class UserDecorator < Draper::Decorator
  delegate_all
  include Draper::LazyHelpers

  def room
    return if user.dormitory.blank?
    return unless Privacy.for(user, 'ROOM_NUMBER').visible
    room = [user.dormitory, user.room].join(' ')
    content_tag(:h4, room, class: 'uk-h4')
  end

  def cell_phone
    return if user.cell_phone.blank?
    return unless Privacy.for(user, 'CELL_PHONE').visible
    content_tag(:h4, user.cell_phone, class: 'uk-h4')
  end

  def email
    return if user.email.blank?
    return unless Privacy.for(user, 'EMAIL').visible
    content_tag(:h4, user.email, class: 'uk-h4')
  end

  def home_address
    return if user.home_address.blank?
    return unless Privacy.for(user, 'ADDRESS').visible ||
      Privacy.for(user, 'HOME_ADDRESS').visible
    content_tag(:h4, user.home_address, class: 'uk-h4')
  end

  def date_of_birth
    return if user.date_of_birth.blank?
    return unless Privacy.for(user, 'DATE_OF_BIRTH').visible
    content_tag(:h4, user.date_of_birth, class: 'uk-h4')
  end

  def nickname
    return if user.nickname.blank?
    user.nickname
  end

  def compact_name
    return user.full_name if user.nickname.blank?
    [user.full_name, ' (', user.nickname, ')'].join
  end

  def messaging_accounts
    im_accounts.decorate.each
  end

  def delegated_for
    return unless user.delegated

    content_tag(:h4, "Küldött itt: " + user.primary_membership.group.name, class: 'uk-h4')
  end
end
