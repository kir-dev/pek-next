module ProfileHelper
  def visibility_select(attribute)
    select_tag(
      "visibility_" + attribute,
      options_for_select(Rails.configuration.x.visibility_options)
    )
  end
end
