module ApplicationHelper

  def oauth_login_path
    '/auth/oauth'
  end

  def stylesheet(*files)
    content_for(:head) { stylesheet_link_tag(*files) }
  end

end
