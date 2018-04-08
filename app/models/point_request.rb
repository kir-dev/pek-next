class PointRequest < ActiveRecord::Base
  self.table_name = "pontigenyles"
  self.primary_key = :id

  alias_attribute :point, :pont
  alias_attribute :evaluation_id, :ertekeles_id
  alias_attribute :user_id, :usr_id

  belongs_to :evaluation, foreign_key: :ertekeles_id
  belongs_to :user, foreign_key: :usr_id
end
