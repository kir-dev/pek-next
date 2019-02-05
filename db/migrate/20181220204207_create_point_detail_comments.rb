class CreatePointDetailComments < ActiveRecord::Migration
  def change
    create_table :point_detail_comments do |t|
      t.text :comment
      t.references :user, index: true, foreign_key: { primary_key: :usr_id }
      t.references :point_detail, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
