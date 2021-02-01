# == Schema Information
#
# Table name: svie_post_requests
#
#  id          :integer          not null, primary key
#  member_type :string
#  user_id     :integer
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class SviePostRequest < ApplicationRecord
  belongs_to :user

  def inside_member?
    member_type == SvieUser::INSIDE_MEMBER
  end

  def outside_member?
    member_type == SvieUser::OUTSIDE_MEMBER
  end

  def inactive_member?
    member_type == SvieUser::INACTIVE_MEMBER
  end
end
