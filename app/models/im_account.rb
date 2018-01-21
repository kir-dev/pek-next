class ImAccount < ActiveRecord::Base
  self.primary_key = :id

  alias_attribute :user_id, :usr_id

  belongs_to :user, foreign_key: :usr_id
end
