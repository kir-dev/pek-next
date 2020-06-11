class AddMembershipStatus < ActiveRecord::Migration[5.0]
  def change
    add_column :memberships, :status, :string
  end
end
