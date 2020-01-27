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
