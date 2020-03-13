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

  FINANCIAL_OFFICER_POST_ID = 1
  LEADER_POST_ID = 3
  PAST_LEADER_ID = 4
  DEFAULT_POST_ID = 6
  PEK_ADMIN_ID = 66
  NEW_MEMBER_ID = 104

  COMMON_TYPES = [
    FINANCIAL_OFFICER_POST_ID,
    LEADER_POST_ID,
    PAST_LEADER_ID,
    DEFAULT_POST_ID,
    PEK_ADMIN_ID,
    NEW_MEMBER_ID
  ].freeze
  scope :without_common, -> { where.not(id: COMMON_TYPES) }
end
