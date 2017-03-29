class GroupMembership < ActiveRecord::Base
  self.table_name = "grp_membership"
  self.primary_key = :id
  LEADER_POST_ID = 3
  DEFAULT_POST_ID = 6
end
