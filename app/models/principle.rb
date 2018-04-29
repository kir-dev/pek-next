class Principle < ActiveRecord::Base
  self.primary_key = :id
  self.inheritance_column = nil #So it won't try to interpret the type column as STI

  belongs_to :evaluation
end
