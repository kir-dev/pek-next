class AddIndexToPointDetail < ActiveRecord::Migration[5.0]
  def change
    add_index :point_details, [:principle_id, :point_request_id], unique: true
  end
end
