# == Schema Information
#
# Table name: post_types
#
#  id             :bigint           not null, primary key
#  group_id       :bigint
#  name           :string(30)       not null
#  delegated_post :boolean          default(FALSE)
#

class PostType < ApplicationRecord
  belongs_to :group, optional: true

  validates :name, presence: true, length: { maximum: 30 }
end
