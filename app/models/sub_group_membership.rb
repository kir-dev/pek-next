# == Schema Information
#
# Table name: sub_group_memberships
#
#  id            :bigint           not null, primary key
#  admin         :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  membership_id :bigint           not null
#  sub_group_id  :bigint           not null
#
# Indexes
#
#  index_sub_group_memberships_on_membership_id                   (membership_id)
#  index_sub_group_memberships_on_sub_group_id                    (sub_group_id)
#  index_sub_group_memberships_on_sub_group_id_and_membership_id  (sub_group_id,membership_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (membership_id => memberships.id)
#  fk_rails_...  (sub_group_id => sub_groups.id)
#

class SubGroupMembership < ApplicationRecord
  belongs_to :sub_group
  belongs_to :membership

  validate :group_must_belong_to_sub_group

  private

  def group_must_belong_to_sub_group
    return if membership.group_id == sub_group.group_id

    errors.add :base,'A körnek a csoporthoz kell tartoznia'
  end
end
