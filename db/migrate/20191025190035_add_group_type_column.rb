class AddGroupTypeColumn < ActiveRecord::Migration
  def change
    add_column :groups, :type, :string
    change_column_null :groups, :grp_type, true
  end
end
