class UserDecorator < Draper::Decorator
  delegate_all
  decorates_association :im_accounts
  include Draper::LazyHelpers

  def room
    return if user.dormitory.blank?
    return unless Privacy.for(user, 'ROOM_NUMBER').visible
    room = [content_tag(:i, "", class: 'uk-icon-building'), user.dormitory,
      user.room].join(' ').html_safe
    content_tag(:h4, room, class: 'uk-h4')
  end

  def cell_phone
    return if user.cell_phone.blank?
    return unless Privacy.for(user, 'CELL_PHONE').visible
    cell_phone_number = 
	        content_tag(:a, 
		user.cell_phone, 
		href: "tel:" + user.cell_phone).html_safe
    cell_phone = [content_tag(:i, "", class: 'uk-icon-phone'),
		  cell_phone_number].join(' ').html_safe
    content_tag(:h4, cell_phone, class: 'uk-h4')
  end

  def email
    return if user.email.blank?
    return unless Privacy.for(user, 'EMAIL').visible
    email_link = content_tag(:a, user.email,
			     href: "mailto:" + user.email).html_safe
    email = [content_tag(:i, "", class: 'uk-icon-envelope'), email_link]
      .join(' ').html_safe
    content_tag(:h4, email, class: 'uk-h4')
  end

  def home_address
    return if user.home_address.blank?
    return unless Privacy.for(user, 'HOME_ADDRESS').visible
    home_address = [content_tag(:i, "", class: 'uk-icon-home'), user.home_address]
      .join(' ').html_safe
    content_tag(:h4, home_address, class: 'uk-h4')
  end

  def date_of_birth
    return if user.date_of_birth.blank?
    return unless Privacy.for(user, 'DATE_OF_BIRTH').visible
    date_of_birth = [content_tag(:i, "", class: 'uk-icon-birthday-cake'),
      user.date_of_birth].join(' ').html_safe
    content_tag(:h4, date_of_birth, class: 'uk-h4')
  end

  def nickname
    return if user.nickname.blank?
    user.nickname
  end

  def compact_name
    return user.full_name if user.nickname.blank?
    [user.full_name, ' (', user.nickname, ')'].join
  end

  def edit_profile_picture_button
    return unless user.id == current_user.id
    icon = content_tag(:i, '', class: 'uk-icon-edit uk-contrast')
    link = link_to(icon, edit_photo_path(current_user.screen_name),
      class: 'uk-align-right uk-link-muted uk-overlay-background uk-padding')
    content_tag(:figcaption, link, class: 'uk-overlay-panel uk-overlay-top')
  end

  def delegated_for
    return unless user.delegated

    content_tag(:h4, "Küldött itt: " + user.primary_membership.group.name, class: 'uk-h4')
  end
end
