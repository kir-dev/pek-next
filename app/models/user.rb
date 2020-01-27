class User < ApplicationRecord
  scope :primary_svie_members, -> { where.not(svie_primary_membership: nil) }

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
