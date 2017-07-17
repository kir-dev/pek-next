class Privacy < ActiveRecord::Base
  self.table_name = 'usr_private_attrs'
  self.primary_key = :id

  alias_attribute :attribute_name, :attr_name

  belongs_to :user, foreign_key: :usr_id

  def self.for(user, attribute)
    find_by(attribute_name: attribute, user: user.id)
  end
end
