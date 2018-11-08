class UserDecorator < Draper::Decorator
  delegate_all
  decorates_association :im_accounts
  include Draper::LazyHelpers

  def room
    return if user.dormitory.blank?
    return unless Privacy.for(user, 'ROOM_NUMBER').visible

    info_box("#{user.dormitory} #{user.room}", 'uk-icon-building')
  end

  def cell_phone
    return if user.cell_phone.blank?
    return unless Privacy.for(user, 'CELL_PHONE').visible

    cell_phone_number = content_tag(:a, user.cell_phone, href: "tel:#{user.cell_phone}")
    info_box(cell_phone_number, 'uk-icon-phone')
  end

  def email
    return if user.email.blank?
    return unless Privacy.for(user, 'EMAIL').visible

    email_link = content_tag(:a, user.email, href: "mailto:#{user.email}")
    info_box(email_link, 'uk-icon-envelope')
  end

  def home_address
    return if user.home_address.blank?
    return unless Privacy.for(user, 'HOME_ADDRESS').visible

    info_box(user.home_address, 'uk-icon-home')
  end

  def date_of_birth
    return if user.date_of_birth.blank?
    return unless Privacy.for(user, 'DATE_OF_BIRTH').visible

    info_box(user.date_of_birth, 'uk-icon-cake')
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

  private

  def info_box(content, icon)
    icon = icon_tag(icon)
    content_tag(:h4, "#{icon} #{content}".html_safe, class: 'uk-h4')
  end
end
