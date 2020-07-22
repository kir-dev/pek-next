class AddIndexToPost < ActiveRecord::Migration[5.0]
  def change
    add_index :posts, [:membership_id, :post_type_id], unique: true
  end
end
