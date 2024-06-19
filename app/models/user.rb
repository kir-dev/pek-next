# == Schema Information
#
# Table name: users
#
#  id                      :bigint           not null, primary key
#  birth_name              :string
#  cell_phone              :string(50)
#  date_of_birth           :date
#  delegated               :boolean          default(FALSE), not null
#  dormitory               :string(50)
#  email                   :string(64)
#  est_grad                :string(10)
#  firstname               :text             not null
#  gender                  :string(50)       default("NOTSPECIFIED"), not null
#  home_address            :string(255)
#  last_login              :datetime
#  lastname                :text             not null
#  metascore               :integer
#  mother_name             :string(100)
#  neptun                  :string
#  nickname                :text
#  password                :string(28)
#  photo_path              :string(255)
#  place_of_birth          :string
#  room                    :string(255)
#  rvt_helper              :boolean          default(FALSE)
#  salt                    :string(12)
#  screen_name             :string(50)       not null
#  show_recommended_photo  :boolean          default(FALSE), not null
#  status                  :string(8)        default("INACTIVE"), not null
#  student_status          :string(50)       default("UNKNOWN"), not null
#  svie_member_type        :string(255)      default("NEMTAG"), not null
#  svie_primary_membership :bigint
#  webpage                 :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  auth_sch_id             :string
#  bme_id                  :string
#
# Indexes
#
#  users_usr_auth_sch_id_key  (auth_sch_id) UNIQUE
#  users_usr_bme_id_key       (bme_id) UNIQUE
#  users_usr_id_idx           (id) UNIQUE
#  users_usr_neptun_idx       (upper((neptun)::text)) UNIQUE
#  users_usr_neptun_key       (neptun) UNIQUE
#  users_usr_screen_name_idx  (upper((screen_name)::text)) UNIQUE
#  users_usr_screen_name_key  (screen_name) UNIQUE
#
# Foreign Keys
#
#  users_main_group_fkey  (svie_primary_membership => memberships.id)
#

class User < ApplicationRecord
  paginates_per 50

  scope :primary_svie_members, -> { where.not(svie_primary_membership: nil) }

  acts_as_target
  has_paper_trail skip: [:last_login, :metascore]

  has_many :memberships
  has_many :groups, through: :memberships
  has_many :sub_groups, through: :memberships
  has_many :entry_requests
  has_many :point_requests
  has_many :im_accounts
  has_many :point_history
  has_many :privacies

  has_one :primary_membership, class_name: :Membership, foreign_key: :id,
          primary_key: :svie_primary_membership
  has_one :svie_post_request
  has_one :view_setting

  validates :screen_name, uniqueness: { case_sensitive: false }
  validates :auth_sch_id, uniqueness: true, allow_nil: true
  validates :bme_id, uniqueness: true, allow_nil: true

  # If primary group is not SVIE
  # validates_with PrimaryMembershipValidator

  # Before validation need to fix cell phone numbers
  # validates_format_of :cell_phone, with: %r{\A\+?[0-9x]+$\z}, allow_blank: true
  validates_format_of :screen_name, without: %r{[\\/]+}

  def self.with_full_name
    full_names = select('*', "lower(concat(lastname,' ',firstname)) as full_name ")
    from(full_names, :users)
  end

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

  def leader_assistant_of?(group)
    membership = membership_for(group)
    membership&.leader_assistant?
  end

  def sub_group_admin_of?(group)
    membership = membership_for(group)
    SubGroupMembership.joins(:sub_group).where('sub_groups.group_id': group.id,
                                               membership: membership, admin: true).any?
  end

  def member_of?(group)
    membership = membership_for(group)
    membership&.active?
  end

  def evaluation_helper_of?(group)
    membership = membership_for(group)
    membership&.evaluation_helper?
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
