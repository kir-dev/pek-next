class AddArchiveToMembeships < ActiveRecord::Migration
  def change
    add_column :groups, :grp_archived_members_visible, :BOOLEAN
    add_column :grp_membership, :archived, :DATE
  end
end
