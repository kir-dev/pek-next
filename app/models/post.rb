# == Schema Information
#
# Table name: posts
#
#  id            :bigint           not null, primary key
#  membership_id :bigint
#  post_type_id  :bigint
#

class Post < ApplicationRecord
  belongs_to :post_type
  belongs_to :membership

  validates :membership_id, uniqueness: { scope: :post_type_id }

  def leader?
    post_type_id == Membership::LEADER_POST_ID
  end
end
