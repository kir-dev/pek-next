class CreatePointDetails < ActiveRecord::Migration
  def change
    create_table :point_details do |t|
      t.references :principle
      t.references :point_request
      t.integer :point
    end
  end
end
