class AddRecommendationsAndFinalizedToEntryRequest < ActiveRecord::Migration[6.0]
  def change
    add_column :entry_requests, :finalized, :boolean, default: false, null: false
    add_index  :entry_requests, :finalized
    add_column :entry_requests, :recommendations, :jsonb,  null: false, default: {}
  end
end
