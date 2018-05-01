class AddBirthNameAndBirthPlaceToUsers < ActiveRecord::Migration
  def up
    add_column :users, :usr_place_of_birth, :string, null: true
    add_column :users, :usr_birth_name, :string, null: true
  end

  def down
    remove_column :users, :usr_place_of_birth
    remove_column :users, :usr_birth_name
  end
end
