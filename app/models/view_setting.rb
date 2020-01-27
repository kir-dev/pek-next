# == Schema Information
#
# Table name: view_settings
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  items_per_page :integer
#  show_pictures  :boolean          default(TRUE)
#  listing        :integer          default("list")
#

class ViewSetting < ApplicationRecord
  enum listing: %i[grid list]

  belongs_to :user
end
