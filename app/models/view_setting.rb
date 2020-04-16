# == Schema Information
#
# Table name: view_settings
#
#  id             :integer          not null, primary key
#  items_per_page :integer
#  listing        :integer          default("list")
#  show_pictures  :boolean          default(TRUE)
#  user_id        :integer
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class ViewSetting < ApplicationRecord
  enum listing: %i[grid list]

  belongs_to :user
end
