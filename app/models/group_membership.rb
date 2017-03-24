class GroupMembership < ActiveRecord::Base
  self.table_name = "grp_membership"
  self.primary_key = :id
end
