class PointDetailCommentDecorator < Draper::Decorator
  delegate_all

  def sender_screen_name
    user.screen_name
  end

  def sender_full_name
    user.full_name
  end

  def image_tag
    path = h.photo_path(sender_screen_name)
    h.image_tag path, alt: sender_full_name,
                      class: 'uk-comment-avatar uk-margin-small-top profile-picture'
  end

  def edit_button
    return unless user == h.current_user

    h.link_to h.edit_point_detail_comment_path(id),
              class: 'uk-button-link uk-link-muted uk-button uk-padding-remove',
              remote: true, 'uk-tooltip': '', title: 'Szerkesztés' do
      h.tag(:i, class: 'uk-icon-edit')
    end
  end

  def delete_button
    return unless user == h.current_user

    h.link_to h.point_detail_comment_path(id),remote: true, method: :delete, data: {confirm: "Biztos törlöd a megjegyzést?"},
                class: 'uk-button-link uk-link-muted uk-button uk-padding-remove uk-margin-small-left uk-margin-small-right',
              'uk-tooltip': '', title: 'Törlés' do
      h.tag(:i, class: 'uk-icon-trash')
    end
  end

  def closing_status
    return unless closing

    h.content_tag(:div, class: 'uk-clearfix') do
      h.content_tag(:span, "záró komment", class: 'uk-align-right')
    end
  end
end
