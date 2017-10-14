class Evaulation < ActiveRecord::Base
  self.table_name = "ertekelesek"
  self.primary_key = :id

  alias_attribute :entry_request_status, :belepoigeny_statusz
  alias_attribute :timestamp, :feladas
  alias_attribute :point_request_status, :pontigeny_statusz
  alias_attribute :semester, :semester
  alias_attribute :justification, :szoveges_ertekeles
  alias_attribute :last_evaulation, :utolso_elbiralas
  alias_attribute :last_modification, :utolso_modositas
  alias_attribute :reviewer_user_id, :elbiralo_usr_id
  alias_attribute :group_id, :grp_id
  alias_attribute :creator_user_id, :felado_usr_id
  alias_attribute :principle, :pontozasi_elvek

  belongs_to :evaluation_id, foreign_key: :evaluation_id
  has_one :point_request
  has_one :entry_request
end
