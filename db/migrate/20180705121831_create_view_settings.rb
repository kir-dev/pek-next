class CreateViewSettings < ActiveRecord::Migration
  def change
    create_table :view_settings do |t|
      t.references :user
      t.integer :items_per_page
      t.boolean :show_pictures, default: true
      t.integer :listing, default: 1
    end
  end
end
