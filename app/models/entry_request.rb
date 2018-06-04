class EntryRequest < ActiveRecord::Base
  self.table_name = 'belepoigenyles'
  self.primary_key = :id

  alias_attribute :entry_type, :belepo_tipus
  alias_attribute :justification, :szoveges_ertekeles
  alias_attribute :evaluation_id, :ertekeles_id
  alias_attribute :user_id, :usr_id

  belongs_to :evaluation, foreign_key: :ertekeles_id
  belongs_to :user, foreign_key: :usr_id

  before_save :remove_justification

  AB = 'AB'
  KB = 'KB'
  KDO = 'KDO'
  DEFAULT_TYPE = KDO

  after_save do
    evaluation.update_last_change!
  end

  def remove_justification
    return unless entry_type == KDO
    self.justification = ''
  end
end
