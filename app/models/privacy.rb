class Privacy < ApplicationRecord
  self.table_name = 'usr_private_attrs'
  self.primary_key = :id

  alias_attribute :attribute_name, :attr_name

  belongs_to :user, foreign_key: :usr_id

  def self.for(user, attribute)
    find_by(attribute_name: attribute, user: user) ||
      Privacy.create(attribute_name: attribute, user: user, visible: default_value(attribute))
  end

  def self.default_value(attribute)
    %w[WEBPAGE CELL_PHONE EMAIL ROOM_NUMBER HOME_ADDRESS DATE_OF_BIRTH'].include?(attribute)
  end
end
