class Poszt < ActiveRecord::Base
  self.table_name = "poszt" #Otherwise Rails would auto-pluralize
  self.primary_key = :id
end
