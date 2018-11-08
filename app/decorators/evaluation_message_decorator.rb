class EvaluationMessageDecorator < Draper::Decorator
  delegate_all
  include Draper::LazyHelpers

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def sender_user_name
    return 'Rendszerüzenet' if sender_user.nil?

    sender_user.full_name
  end

  def sender_profile_picture
    if sender_user.nil?
      return image_tag '/img/system.png', class: 'uk-comment-avatar profile-picture'
    end

    image_tag photo_path(sender_user.screen_name), alt: sender_user.full_name,
                                                   class: 'uk-comment-avatar profile-picture'
  end
end
