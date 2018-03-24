class EntryRequest < ActiveRecord::Base
  self.table_name = 'belepoigenyles'
  self.primary_key = :id

  alias_attribute :entry_type, :belepo_tipus
  alias_attribute :explanation, :szoveges_ertekeles
  alias_attribute :evaluation_id, :ertekeles_id
  alias_attribute :user_id, :usr_id

  belongs_to :evaluation, foreign_key: :evaluation_id
  belongs_to :user, foreign_key: :usr_id

  AB = :AB
  KB = :KB
  KDO = :KDO
  DEFAULT_TYPE = KDO
end
