class Version::Wrapper
  attr_reader :model, :records

  def initialize(records)
    @model = records.model.to_s
    @records = records
  end

  def versions
    @versions ||= decorate_versions
  end

  def version_authors
    @version_authors ||= User.find(@versions.map(&:version_author))
  end

  private

  def query_base
    PaperTrail::Version
  end

  def select_versions
    @versions = query_base.where(item_type: @model, item_id: records.ids)
  end

  def decorate_versions
    Version::Decorator.decorate_collection(select_versions, context: { version_authors: version_authors})
  end
end
