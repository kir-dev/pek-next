class Post < ApplicationRecord
  belongs_to :post_type

  def leader?
    post_type_id == Membership::LEADER_POST_ID
  end
end
