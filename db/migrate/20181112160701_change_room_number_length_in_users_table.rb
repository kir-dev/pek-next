class ChangeRoomNumberLengthInUsersTable < ActiveRecord::Migration

  def up
    change_column :users, :usr_room, :string, :limit => 255
  end

  def down
    change_column :users, :usr_room, :string, :limit => 10
  end

end
