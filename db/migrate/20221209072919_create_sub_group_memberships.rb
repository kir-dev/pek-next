class CreateSubGroupMemberships < ActiveRecord::Migration[6.0]
  def change
    create_table :sub_group_memberships do |t|
      t.references :sub_group, null: false, foreign_key: true
      t.references :membership, null: false, foreign_key: true
      t.index [:sub_group_id, :membership_id], unique: true
      t.timestamps
    end
  end
end
