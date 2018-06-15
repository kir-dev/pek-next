class EvaluationMessage < ActiveRecord::Base
  self.table_name = 'ertekeles_uzenet'
  self.primary_key = :id

  alias_attribute :sent_at, :feladas_ido
  alias_attribute :message, :uzenet
  alias_attribute :sender_user_id, :felado_usr_id

  belongs_to :group
  belongs_to :sender_user, class_name: 'User', foreign_key: :felado_usr_id

end
