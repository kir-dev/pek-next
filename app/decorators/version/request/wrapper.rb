class Version::Request::Wrapper < Version::Wrapper
  private

  def decorate_versions
    Version::Request::Decorator.decorate_collection(select_versions, context: { version_authors: version_authors})
  end

  def query_base
    PaperTrail::Version.includes(item: :user)
  end
end
