class User < ActiveRecord::Base
  self.primary_key = :usr_id

  alias_attribute :id, :usr_id
  alias_attribute :email, :usr_email
  alias_attribute :neptun, :usr_neptun
  alias_attribute :firstname, :usr_firstname
  alias_attribute :lastname, :usr_lastname
  alias_attribute :nickname, :usr_nickname
  alias_attribute :svie_state, :usr_svie_state
  alias_attribute :svie_member_type, :usr_svie_member_type
  alias_attribute :svie_primary_membership, :usr_svie_primary_membership
  alias_attribute :delegated, :usr_delegated
  alias_attribute :show_recommended_photo, :usr_show_recommended_photo
  alias_attribute :screen_name, :usr_screen_name
  alias_attribute :date_of_birth, :usr_date_of_birth
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
  alias_attribute :lastlogin, :usr_lastlogin

  validates :usr_screen_name, uniqueness: true
  validates :usr_auth_sch_id, uniqueness: true
  validates :usr_bme_id, uniqueness: true, allow_nil: true
end
