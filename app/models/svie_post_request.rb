class SviePostRequest < ActiveRecord::Base
  belongs_to :user, foreign_key: :usr_id

  def inside_member?
    self.member_type == 'BELSOSTAG'
  end

  def outside_member?
    self.member_type == 'KULSOSTAG'
  end

  def inactive_member?
    self.member_type == 'OREGTAG'
  end

end
