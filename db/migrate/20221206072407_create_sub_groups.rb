class CreateSubGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :sub_groups do |t|
      t.string :name
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
