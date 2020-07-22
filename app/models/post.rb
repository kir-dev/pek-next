# == Schema Information
#
# Table name: posts
#
#  id            :bigint           not null, primary key
#  membership_id :bigint
#  post_type_id  :bigint
#
# Indexes
#
#  index_posts_on_membership_id_and_post_type_id  (membership_id,post_type_id) UNIQUE
#  poszt_fk_idx                                   (membership_id)
#
# Foreign Keys
#
#  poszt_grp_member_fk  (membership_id => memberships.id) ON DELETE => cascade ON UPDATE => cascade
#  poszt_pttip_fk       (post_type_id => post_types.id) ON DELETE => cascade ON UPDATE => cascade
#

class Post < ApplicationRecord
  belongs_to :post_type
  belongs_to :membership

  validates :membership_id, uniqueness: { scope: :post_type_id }

  def leader?
    post_type_id == PostType::LEADER_POST_ID
  end
end
