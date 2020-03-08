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

  has_many :posts

  validates :name, presence: true, length: { maximum: 30 }

  COMMON_TYPES = [
    Membership::FINANCIAL_OFFICER_POST_ID,
    Membership::LEADER_POST_ID,
    Membership::PAST_LEADER_ID,
    Membership::DEFAULT_POST_ID,
    Membership::PEK_ADMIN_ID,
    Membership::NEW_MEMBER_ID
  ].freeze
  scope :without_common, -> { where.not(id: COMMON_TYPES) }
end
