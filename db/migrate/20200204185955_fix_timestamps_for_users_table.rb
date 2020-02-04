class FixTimestampsForUsersTable < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :usr_created_at, :created_at
    add_column :users, :updated_at, :timestamp
  end
end
