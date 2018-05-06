class AddBirthNameAndBirthPlaceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :usr_place_of_birth, :string, null: true
    add_column :users, :usr_birth_name, :string, null: true
  end
end
