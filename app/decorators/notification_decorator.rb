class NotificationDecorator < Draper::Decorator
  delegate_all
  include Draper::LazyHelpers

  def sender
    return 'PéK' unless notifier.present?

    notifier.decorate.link
  end

  def sender_profile_picture(options = {})
    if notifier.present?
      path = photo_path(notifier.screen_name)
      options[:alt] = notifier.full_name
    end

    image_tag path || '/img/system.png', options
  end

  def mark_as_read_link(options = {})
    return unless unopened?

    options[:method] = :post
    options[:remote] = true
    path = open_notification_path_for(self, base_params.merge(reload: false))
    link = link_to('Olvasottnak jelölés', path, options)

    "| #{link}".html_safe
  end

  def open_link(options = {})
    return unless notifiable.present?

    if unopened?
      path = open_notification_path_for(self, base_params.merge(move: true))
      options[:method] = :post
    else
      path = move_notification_path_for(self, base_params)
    end
    link = link_to('Megnyitás', path, options)

    "| #{link}".html_safe
  end

  private

  def base_params
    parameters.slice(:routing_scope, :devise_default_routes)
  end
end
