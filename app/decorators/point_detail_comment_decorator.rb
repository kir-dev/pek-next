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
end
