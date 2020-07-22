class AddIndexToPointHistory < ActiveRecord::Migration[5.0]
  def change
    add_index :point_histories, [:user_id, :semester], unique: true
  end
end
