module EntryRequestHelper
  def resort_recommendations_tooltip(recommendations)
    result = []

    recommendations_by_type = recommendations.sort_by { |resort_id, recommendation| recommendation}
    recommendations_by_type.each do |resort_id, recommendation|
      resort = @resorts.find{|r| r.id == resort_id.to_i}
      result << "#{Rails.configuration.x.entry_types[recommendation]} - #{resort.name}"
    end
    result.join("\n")
  end
end
