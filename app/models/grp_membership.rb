class GrpMembership < ActiveRecord::Base
  self.table_name = "grp_membership" #Otherwise Rails would auto-pluralize
  self.primary_key = :id
end
