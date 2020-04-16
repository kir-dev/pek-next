# == Schema Information
#
# Table name: privacies
#
#  id             :bigint           not null, primary key
#  attribute_name :string(64)       not null
#  visible        :boolean          default(FALSE), not null
#  user_id        :bigint           not null
#
# Foreign Keys
#
#  usr_private_attrs_usr_id_fkey  (user_id => users.id)
#

class Privacy < ApplicationRecord
  belongs_to :user

  def self.for(user, attribute)
    find_by(attribute_name: attribute, user: user) ||
      Privacy.create(attribute_name: attribute, user: user, visible: default_value(attribute))
  end

  def self.default_value(attribute)
    %w[WEBPAGE CELL_PHONE EMAIL ROOM_NUMBER HOME_ADDRESS DATE_OF_BIRTH'].include?(attribute)
  end
end
