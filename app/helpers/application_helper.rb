module ApplicationHelper
  def oauth_login_path
    '/auth/oauth'
  end

  def stylesheet(*files)
    content_for(:head) { stylesheet_link_tag(*files) }
  end

  def list?
    !!current_user.view_setting&.list?
  end

  def show_images?
    view_setting = current_user.view_setting
    return view_setting.show_pictures if view_setting

    true
  end

  def items_per_page
    view_setting = current_user.view_setting
    return view_setting.items_per_page if view_setting

    Kaminari.config.default_per_page
  end

  def icon_tag(icon, title = '')
    content_tag(:i, '', class: icon, 'data-uk-tooltip': '', title: title)
  end

  def random_cat_image
    image_params = { query: 'cats', width: 1920, height: 1080, orientation: 'landscape' }
    Unsplash::Photo.random(image_params) rescue nil
  end

  def hu_compare(a, b)
    HungarianComparator.compare(a, b)
  end

  def array_to_csv(array)
    CSV.generate do |lines|
      array.each do |line|
        lines << line
      end
    end
  end
end
