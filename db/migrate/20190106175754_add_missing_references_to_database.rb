class AddMissingReferencesToDatabase < ActiveRecord::Migration
  def change
    add_foreign_key :point_details, :pontigenyles, column: :point_request_id
    add_foreign_key :point_details, :principles

    add_foreign_key :principles, :ertekelesek, column: :evaluation_id

    add_foreign_key :view_settings, :users, primary_key: :usr_id
  end
end
