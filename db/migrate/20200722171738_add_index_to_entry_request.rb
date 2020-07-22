class AddIndexToEntryRequest < ActiveRecord::Migration[5.0]
  def change
    add_index :entry_requests, [:evaluation_id, :user_id], unique: true
  end
end
