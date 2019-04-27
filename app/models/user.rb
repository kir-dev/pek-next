# == Schema Information
#
# Table name: users
#
#  id                      :bigint           not null, primary key
#  email                   :string(64)
#  neptun                  :string
#  firstname               :text             not null
#  lastname                :text             not null
#  nickname                :text
#  svie_member_type        :string(255)      default("NEMTAG"), not null
#  svie_primary_membership :bigint
#  delegated               :boolean          default(FALSE), not null
#  show_recommended_photo  :boolean          default(FALSE), not null
#  screen_name             :string(50)       not null
#  date_of_birth           :date
#  gender                  :string(50)       default("NOTSPECIFIED"), not null
#  student_status          :string(50)       default("UNKNOWN"), not null
#  mother_name             :string(100)
#  photo_path              :string(255)
#  webpage                 :string(255)
#  cell_phone              :string(50)
#  home_address            :string(255)
#  est_grad                :string(10)
#  dormitory               :string(50)
#  room                    :string(255)
#  status                  :string(8)        default("INACTIVE"), not null
#  password                :string(28)
#  salt                    :string(12)
#  last_login              :datetime
#  auth_sch_id             :string
#  bme_id                  :string
#  created_at              :datetime
#  metascore               :integer
#  place_of_birth          :string
#  birth_name              :string
#  updated_at              :datetime
#

class User < ApplicationRecord
  scope :primary_svie_members, -> { where.not(svie_primary_membership: nil) }

  acts_as_target

  has_many :memberships
  has_many :groups, through: :memberships
  has_many :entry_requests
  has_many :point_requests
  has_many :im_accounts
  has_many :point_history
  has_many :privacies

  has_one :primary_membership, class_name: :Membership, foreign_key: :id,
                               primary_key: :svie_primary_membership
  has_one :svie_post_request
  has_one :view_setting

  validates :screen_name, uniqueness: {case_sensitive: false}
  validates :auth_sch_id, uniqueness: true, allow_nil: true
  validates :bme_id, uniqueness: true, allow_nil: true

  # If primary group is not SVIE
  # validates_with PrimaryMembershipValidator

  # Before validation need to fix cell phone numbers
  # validates_format_of :cell_phone, with: %r{\A\+?[0-9x]+$\z}, allow_blank: true
  validates_format_of :screen_name, without: %r{[\\/]+}

  def full_name
    "#{lastname} #{firstname}"
  end

  def transliterated_full_name
    I18n.transliterate(full_name)
  end

  def membership_for(group)
    memberships.find { |m| m.group == group }
  end

  def leader_of?(group)
    membership = membership_for(group)
    membership&.leader?
  end

  def member_of?(group)
    membership = membership_for(group)
    membership&.active?
  end

  def roles
    @roles ||= UserRole.new(self)
  end

  def svie
    @svie_user ||= SvieUser.new(self)
  end

  def update_last_login!
    update(last_login: Time.now)
  end

  def eliglibe_member?(group_id)
    return false unless primary_membership

    primary_membership.active? && primary_membership.group_id == group_id
  end
end
