# == Schema Information
#
# Table name: evaluation_messages
#
#  id             :bigint           not null, primary key
#  from_system    :boolean          default(FALSE)
#  message        :text
#  semester       :string(9)        not null
#  sent_at        :datetime
#  group_id       :bigint
#  sender_user_id :bigint
#
# Indexes
#
#  fki_felado_usr_id  (sender_user_id)
#  fki_group_id       (group_id)
#
# Foreign Keys
#
#  fk_felado_usr_id  (sender_user_id => users.id) ON DELETE => nullify
#  fk_group_id       (group_id => groups.id) ON DELETE => cascade
#

class EvaluationMessage < ApplicationRecord
  belongs_to :group
  belongs_to :sender_user, class_name: 'User', foreign_key: :sender_user_id
end
