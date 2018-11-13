class User < ActiveRecord::Base
  self.primary_key = :usr_id

  alias_attribute :id, :usr_id
  alias_attribute :email, :usr_email
  alias_attribute :neptun, :usr_neptun
  alias_attribute :firstname, :usr_firstname
  alias_attribute :lastname, :usr_lastname
  alias_attribute :nickname, :usr_nickname
  # TODO: there should be a better way to access all this SVIE stuff
  alias_attribute :svie_state, :usr_svie_state
  alias_attribute :svie_member_type, :usr_svie_member_type
  alias_attribute :svie_primary_membership, :usr_svie_primary_membership
  alias_attribute :delegated, :usr_delegated
  alias_attribute :show_recommended_photo, :usr_show_recommended_photo
  alias_attribute :screen_name, :usr_screen_name
  alias_attribute :date_of_birth, :usr_date_of_birth
  alias_attribute :place_of_birth, :usr_place_of_birth
  alias_attribute :birth_name, :usr_birth_name
  alias_attribute :gender, :usr_gender
  alias_attribute :student_status, :usr_student_status
  alias_attribute :mother_name, :usr_mother_name
  alias_attribute :photo_path, :usr_photo_path
  alias_attribute :webpage, :usr_webpage
  alias_attribute :cell_phone, :usr_cell_phone
  alias_attribute :home_address, :usr_home_address
  alias_attribute :est_grad, :usr_est_grad
  alias_attribute :dormitory, :usr_dormitory
  alias_attribute :room, :usr_room
  alias_attribute :confirm, :usr_confirm
  alias_attribute :status, :usr_status
  alias_attribute :password, :usr_password
  alias_attribute :salt, :usr_salt
  alias_attribute :last_login, :usr_lastlogin
  alias_attribute :metascore, :usr_metascore
  alias_attribute :auth_sch_id, :usr_auth_sch_id
  alias_attribute :bme_id, :usr_bme_id

  has_many :memberships, class_name: "Membership", foreign_key: :usr_id
  has_many :groups, through: :memberships
  has_many :entryrequests, class_name: "EntryRequest", foreign_key: :usr_id
  has_many :pointrequests, class_name: "PointRequest", foreign_key: :usr_id
  has_many :im_accounts, foreign_key: :usr_id
  has_many :point_history, foreign_key: :usr_id
  has_many :privacies, foreign_key: :usr_id

  has_one :primary_membership, class_name: "Membership", foreign_key: :id, primary_key: :usr_svie_primary_membership
  has_one :svie_post_request, foreign_key: :usr_id, primary_key: :id
  has_one :view_setting

  validates :screen_name, uniqueness: true
  validates :auth_sch_id, uniqueness: true, allow_nil: true
  validates :bme_id, uniqueness: true, allow_nil: true

  # If primary group is not SVIE
  # validates_with PrimaryMembershipValidator

  # Before validation need to fix cell phone numbers
  # validates_format_of :cell_phone, with: /\A\+?[0-9x]+$\z/, allow_blank: true
  validates_format_of :screen_name, without: /[\\\/]+/

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
    membership && membership.leader?
  end

  def member_of?(group)
    membership = membership_for(group)
    membership && membership.active?
  end

  def roles
    @roles ||= UserRole.new(self)
  end

  def svie
    @svie_user ||= SvieUser.new(self)
  end

  def update_last_login!
    self.update(last_login: Time.now)
  end

end
