class SviePostRequest < ActiveRecord::Base
  belongs_to :user, foreign_key: :usr_id

  def inside_member?
    self.member_type == SvieUser::INSIDE_MEMBER
  end

  def outside_member?
    self.member_type == SvieUser::OUTSIDE_MEMBER
  end

  def inactive_member?
    self.member_type == SvieUser::INACTIVE_MEMBER
  end

end
