class Post < ActiveRecord::Base
  self.table_name = "poszt"
  self.primary_key = :id
end
