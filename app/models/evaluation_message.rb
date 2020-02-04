# == Schema Information
#
# Table name: evaluation_messages
#
#  id             :bigint           not null, primary key
#  sent_at        :datetime
#  message        :text
#  sender_user_id :bigint
#  group_id       :bigint
#  semester       :string(9)        not null
#  from_system    :boolean          default(FALSE)
#

class EvaluationMessage < ApplicationRecord
  belongs_to :group
  belongs_to :sender_user, class_name: 'User', foreign_key: :sender_user_id
end
