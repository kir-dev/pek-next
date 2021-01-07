class Version::Request::Decorator < Version::Decorator
  def request_user
    item.user
  end
end
