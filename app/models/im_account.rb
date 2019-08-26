class ImAccount < ApplicationRecord
  self.primary_key = :id

  alias_attribute :user_id, :usr_id
  alias_attribute :name, :account_name

  belongs_to :user, foreign_key: :usr_id
end
