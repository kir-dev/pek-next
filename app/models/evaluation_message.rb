class EvaluationMessage < ApplicationRecord
  belongs_to :group
  belongs_to :sender_user, class_name: 'User', foreign_key: :sender_user_id
end
