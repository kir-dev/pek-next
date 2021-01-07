class Version::Decorator < Draper::Decorator
  delegate_all

  def whodunnit
    context[:version_authors].find(super).first
  end

  def type
    item_type.underscore
  end
end
