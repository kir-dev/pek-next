# == Schema Information
#
# Table name: sub_groups
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :bigint           not null
#
# Indexes
#
#  index_sub_groups_on_group_id  (group_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#

class SubGroup < ApplicationRecord
  belongs_to :group
  has_many :sub_group_memberships
  has_many :memberships, through: :sub_group_memberships
  has_many :users, through: :memberships
  has_many :principles
  validates :name, presence: true
  validates :group_id, presence: true

  def sub_group_memberships_for(user:)
    sub_group_memberships.joins(:membership).find_by(memberships: { user: user })
  end

  def admins
    User.joins(memberships: :sub_group_memberships)
        .where('sub_group_memberships.sub_group_id': id, 'sub_group_memberships.admin': true)
  end
end
