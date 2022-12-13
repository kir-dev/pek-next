class AddAdminAttributeToSubGroupMemberships < ActiveRecord::Migration[6.0]
  def change
    add_column :sub_group_memberships, :admin, :boolean, default: false
  end
end
