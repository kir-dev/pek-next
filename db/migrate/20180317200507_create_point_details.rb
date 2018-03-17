class CreatePointDetails < ActiveRecord::Migration
  def change
    create_table :point_details do |t|
      t.integer :principle_id
      t.bigint :point_request_id
      t.integer :point
    end
  end
end
