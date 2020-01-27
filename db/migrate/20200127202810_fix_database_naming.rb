class FixDatabaseNaming < ActiveRecord::Migration[5.0]
  def change
    rename_table :belepoigenyles, :entry_requests
    rename_column :entry_requests, :belepo_tipus, :entry_type
    rename_column :entry_requests, :szoveges_ertekeles, :justification
    rename_column :entry_requests, :ertekeles_id, :evaluation_id
    rename_column :entry_requests, :usr_id, :user_id

    rename_table :ertekeles_uzenet, :evaluation_messages
    rename_column :evaluation_messages, :feladas_ido, :sent_at
    rename_column :evaluation_messages, :uzenet, :message
    rename_column :evaluation_messages, :felado_usr_id, :sender_user_id

    rename_table :ertekelesek, :evaluations
    rename_column :evaluations, :belepoigeny_statusz, :entry_request_status
    rename_column :evaluations, :feladas, :timestamp
    rename_column :evaluations, :pontigeny_statusz, :point_request_status
    rename_column :evaluations, :szoveges_ertekeles, :justification
    rename_column :evaluations, :utolso_elbiralas, :last_evaulation
    rename_column :evaluations, :utolso_modositas, :last_modification
    rename_column :evaluations, :elbiralo_usr_id, :reviewer_user_id
    rename_column :evaluations, :grp_id, :group_id
    rename_column :evaluations, :felado_usr_id, :creator_user_id
    rename_column :evaluations, :pontozasi_elvek, :principle

    rename_column :groups, :grp_id, :id
    rename_column :groups, :grp_name, :name
    rename_column :groups, :grp_parent, :parent_id
    rename_column :groups, :grp_state, :state
    rename_column :groups, :grp_description, :description
    rename_column :groups, :grp_webpage, :webpage
    rename_column :groups, :grp_maillist, :maillist
    rename_column :groups, :grp_head, :head
    rename_column :groups, :grp_founded, :founded
    rename_column :groups, :grp_issvie, :issvie
    rename_column :groups, :grp_svie_delegate_nr, :delegate_count
    rename_column :groups, :grp_users_can_apply, :users_can_apply
    rename_column :groups, :grp_archived_members_visible, :archived_members_visible

    rename_column :im_accounts, :usr_id, :user_id
    rename_column :im_accounts, :account_name, :name

    rename_table :grp_membership, :memberships
    rename_column :memberships, :grp_id, :group_id
    rename_column :memberships, :usr_id, :user_id
    rename_column :memberships, :membership_start, :start_date
    rename_column :memberships, :membership_end, :end_date

    rename_table :point_history, :point_histories
    rename_column :point_histories, :usr_id, :user_id

    rename_table :pontigenyles, :point_requests
    rename_column :point_requests, :pont, :point
    rename_column :point_requests, :ertekeles_id, :evaluation_id
    rename_column :point_requests, :usr_id, :user_id

    rename_table :poszttipus, :post_types
    rename_column :post_types, :pttip_id, :id
    rename_column :post_types, :pttip_name, :name
    rename_column :post_types, :grp_id, :group_id

    rename_table :poszt, :posts
    rename_column :posts, :grp_member_id, :membership_id
    rename_column :posts, :pttip_id, :post_type_id

    rename_table :usr_private_attrs, :privacies
    rename_column :privacies, :attr_name, :attribute_name
    rename_column :privacies, :usr_id, :user_id

    rename_column :svie_post_requests, :usr_id, :user_id

    rename_table :system_attrs, :system_attributes
    rename_column :system_attributes, :attributeid, :id
    rename_column :system_attributes, :attributevalue, :value
    rename_column :system_attributes, :attributename, :name

    rename_column :users, :usr_id, :id
    rename_column :users, :usr_email, :email
    rename_column :users, :usr_neptun, :neptun
    rename_column :users, :usr_firstname, :firstname
    rename_column :users, :usr_lastname, :lastname
    rename_column :users, :usr_nickname, :nickname
    rename_column :users, :usr_svie_member_type, :svie_member_type
    rename_column :users, :usr_svie_primary_membership, :svie_primary_membership
    rename_column :users, :usr_delegated, :delegated
    rename_column :users, :usr_show_recommended_photo, :show_recommended_photo
    rename_column :users, :usr_screen_name, :screen_name
    rename_column :users, :usr_date_of_birth, :date_of_birth
    rename_column :users, :usr_place_of_birth, :place_of_birth
    rename_column :users, :usr_birth_name, :birth_name
    rename_column :users, :usr_gender, :gender
    rename_column :users, :usr_student_status, :student_status
    rename_column :users, :usr_mother_name, :mother_name
    rename_column :users, :usr_photo_path, :photo_path
    rename_column :users, :usr_webpage, :webpage
    rename_column :users, :usr_cell_phone, :cell_phone
    rename_column :users, :usr_home_address, :home_address
    rename_column :users, :usr_est_grad, :est_grad
    rename_column :users, :usr_dormitory, :dormitory
    rename_column :users, :usr_room, :room
    rename_column :users, :usr_status, :status
    rename_column :users, :usr_password, :password
    rename_column :users, :usr_salt, :salt
    rename_column :users, :usr_lastlogin, :last_login
    rename_column :users, :usr_metascore, :metascore
    rename_column :users, :usr_auth_sch_id, :auth_sch_id
    rename_column :users, :usr_bme_id, :bme_id
  end
end
