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

  def leader?
    post_type_id == Membership::LEADER_POST_ID
  end
end
