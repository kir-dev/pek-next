class CreatePrinciples < ActiveRecord::Migration
  def change
    create_table :principles do |t|
      t.references :evaluation
      t.string :name
      t.string :description
      t.string :type
      t.integer :max_per_member
    end
  end
end
