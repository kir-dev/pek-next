class AddMetascoreToUsers < ActiveRecord::Migration
  def change
    add_column :users, :usr_metascore, :INT
  end
end
