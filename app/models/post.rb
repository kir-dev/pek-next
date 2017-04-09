class Post < ActiveRecord::Base
  self.table_name = "poszt"
  self.primary_key = :id

  belongs_to :post_type, foreign_key: :pttip_id
end
