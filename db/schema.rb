# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161124163851) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "belepoigenyles", id: :bigserial, force: :cascade do |t|
    t.string  "belepo_tipus",       limit: 255
    t.text    "szoveges_ertekeles"
    t.integer "ertekeles_id",       limit: 8,   null: false
    t.integer "usr_id",             limit: 8
  end

  add_index "belepoigenyles", ["belepo_tipus"], name: "bel_tipus_idx", using: :btree

  create_table "ertekeles_uzenet", id: :bigserial, force: :cascade do |t|
    t.datetime "feladas_ido"
    t.text     "uzenet"
    t.integer  "felado_usr_id", limit: 8
    t.integer  "group_id",      limit: 8
    t.string   "semester",      limit: 9,                 null: false
    t.boolean  "from_system",             default: false
  end

  add_index "ertekeles_uzenet", ["felado_usr_id"], name: "fki_felado_usr_id", using: :btree
  add_index "ertekeles_uzenet", ["group_id"], name: "fki_group_id", using: :btree

  create_table "ertekelesek", id: :bigserial, force: :cascade do |t|
    t.string   "belepoigeny_statusz", limit: 255
    t.datetime "feladas"
    t.string   "pontigeny_statusz",   limit: 255
    t.string   "semester",            limit: 9,                   null: false
    t.text     "szoveges_ertekeles",                              null: false
    t.datetime "utolso_elbiralas"
    t.datetime "utolso_modositas"
    t.integer  "elbiralo_usr_id",     limit: 8
    t.integer  "grp_id",              limit: 8
    t.integer  "felado_usr_id",       limit: 8
    t.text     "pontozasi_elvek",                 default: "",    null: false
    t.integer  "next_version",        limit: 8
    t.text     "explanation"
    t.integer  "optlock",                         default: 0,     null: false
    t.boolean  "is_considered",                   default: false, null: false
  end

  add_index "ertekelesek", ["grp_id", "semester", "next_version"], name: "unique_idx", unique: true, using: :btree
  add_index "ertekelesek", ["next_version"], name: "next_version_idx", using: :btree
  add_index "ertekelesek", ["semester"], name: "ert_semester_idx", using: :btree

  create_table "groups", primary_key: "grp_id", force: :cascade do |t|
    t.text    "grp_name",                                        null: false
    t.string  "grp_type",             limit: 20,                 null: false
    t.integer "grp_parent",           limit: 8
    t.string  "grp_state",                       default: "akt"
    t.text    "grp_description"
    t.string  "grp_webpage",          limit: 64
    t.string  "grp_maillist",         limit: 64
    t.string  "grp_head",             limit: 48
    t.integer "grp_founded"
    t.boolean "grp_issvie",                      default: false, null: false
    t.integer "grp_svie_delegate_nr"
    t.boolean "grp_users_can_apply",             default: true,  null: false
  end

  add_index "groups", ["grp_id"], name: "groups_grp_id_idx", unique: true, using: :btree
  add_index "groups", ["grp_name"], name: "idx_groups_grp_name", using: :btree
  add_index "groups", ["grp_type"], name: "idx_groups_grp_type", using: :btree

  create_table "grp_membership", id: :bigserial, force: :cascade do |t|
    t.integer "grp_id",           limit: 8
    t.integer "usr_id",           limit: 8
    t.date    "membership_start",           default: "now()"
    t.date    "membership_end"
  end

  add_index "grp_membership", ["grp_id", "usr_id"], name: "unique_memberships", unique: true, using: :btree
  add_index "grp_membership", ["usr_id"], name: "membership_usr_fk_idx", using: :btree

  create_table "im_accounts", id: :bigserial, force: :cascade do |t|
    t.string  "protocol",     limit: 50,  null: false
    t.string  "account_name", limit: 255, null: false
    t.integer "usr_id",       limit: 8
  end

  create_table "log", id: :bigserial, force: :cascade do |t|
    t.integer "grp_id",   limit: 8
    t.integer "usr_id",   limit: 8,                    null: false
    t.date    "evt_date",            default: "now()"
    t.string  "event",    limit: 30,                   null: false
  end

  create_table "lostpw_tokens", primary_key: "usr_id", force: :cascade do |t|
    t.datetime "created"
    t.string   "token",   limit: 64
  end

  add_index "lostpw_tokens", ["token"], name: "lostpw_tokens_token_key", unique: true, using: :btree

  create_table "neptun_list", primary_key: "neptun", force: :cascade do |t|
    t.string  "nev",          limit: 128,                 null: false
    t.date    "szuldat",                                  null: false
    t.string  "education_id", limit: 11
    t.boolean "newbie",                   default: false
  end

  create_table "point_history", id: :bigserial, force: :cascade do |t|
    t.integer "usr_id",   limit: 8, null: false
    t.integer "point",              null: false
    t.string  "semester", limit: 9, null: false
  end

  create_table "pontigenyles", id: :bigserial, force: :cascade do |t|
    t.integer "pont"
    t.integer "ertekeles_id", limit: 8, null: false
    t.integer "usr_id",       limit: 8
  end

  create_table "poszt", id: :bigserial, force: :cascade do |t|
    t.integer "grp_member_id", limit: 8
    t.integer "pttip_id",      limit: 8
  end

  add_index "poszt", ["grp_member_id"], name: "poszt_fk_idx", using: :btree

  create_table "poszttipus", primary_key: "pttip_id", force: :cascade do |t|
    t.integer "grp_id",         limit: 8
    t.string  "pttip_name",     limit: 30,                 null: false
    t.boolean "delegated_post",            default: false
  end

  create_table "spot_images", id: false, force: :cascade do |t|
    t.string "usr_neptun",             null: false
    t.string "image_path", limit: 255, null: false
  end

  add_index "spot_images", ["usr_neptun"], name: "spot_images_usr_neptun_key", unique: true, using: :btree

  create_table "system_attrs", primary_key: "attributeid", force: :cascade do |t|
    t.string "attributename",  limit: 255, null: false
    t.string "attributevalue", limit: 255, null: false
  end

  create_table "temp_belepo", id: false, force: :cascade do |t|
    t.text   "usr_lastname"
    t.text   "usr_firstname"
    t.text   "usr_nickname"
    t.text   "grp_name"
    t.string "belepo_tipus",       limit: 255
    t.text   "szoveges_ertekeles"
  end

  create_table "users", primary_key: "usr_id", force: :cascade do |t|
    t.string   "usr_email",                   limit: 64
    t.string   "usr_neptun"
    t.text     "usr_firstname",                                                    null: false
    t.text     "usr_lastname",                                                     null: false
    t.text     "usr_nickname"
    t.string   "usr_svie_state",              limit: 255, default: "NEMTAG",       null: false
    t.string   "usr_svie_member_type",        limit: 255, default: "NEMTAG",       null: false
    t.integer  "usr_svie_primary_membership", limit: 8
    t.boolean  "usr_delegated",                           default: false,          null: false
    t.boolean  "usr_show_recommended_photo",              default: false,          null: false
    t.string   "usr_screen_name",             limit: 50,                           null: false
    t.date     "usr_date_of_birth"
    t.string   "usr_gender",                  limit: 50,  default: "NOTSPECIFIED", null: false
    t.string   "usr_student_status",          limit: 50,  default: "UNKNOWN",      null: false
    t.string   "usr_mother_name",             limit: 100
    t.string   "usr_photo_path",              limit: 255
    t.string   "usr_webpage",                 limit: 255
    t.string   "usr_cell_phone",              limit: 50
    t.string   "usr_home_address",            limit: 255
    t.string   "usr_est_grad",                limit: 10
    t.string   "usr_dormitory",               limit: 50
    t.string   "usr_room",                    limit: 10
    t.string   "usr_status",                  limit: 8,   default: "INACTIVE",     null: false
    t.string   "usr_password",                limit: 28
    t.string   "usr_salt",                    limit: 12
    t.datetime "usr_lastlogin"
    t.string   "usr_auth_sch_id"
    t.string   "usr_bme_id"
    t.datetime "usr_created_at"
  end

  add_index "users", ["usr_auth_sch_id"], name: "users_usr_auth_sch_id_key", unique: true, using: :btree
  add_index "users", ["usr_bme_id"], name: "users_usr_bme_id_key", unique: true, using: :btree
  add_index "users", ["usr_id"], name: "users_usr_id_idx", unique: true, using: :btree
  add_index "users", ["usr_neptun"], name: "users_usr_neptun_key", unique: true, using: :btree
  add_index "users", ["usr_screen_name"], name: "users_usr_screen_name_key", unique: true, using: :btree

  create_table "usr_private_attrs", id: :bigserial, force: :cascade do |t|
    t.integer "usr_id",    limit: 8,                  null: false
    t.string  "attr_name", limit: 64,                 null: false
    t.boolean "visible",              default: false, null: false
  end

  add_foreign_key "belepoigenyles", "ertekelesek", column: "ertekeles_id", name: "fk_ertekeles_id", on_delete: :cascade
  add_foreign_key "belepoigenyles", "users", column: "usr_id", primary_key: "usr_id", name: "fk4e301ac36958e716"
  add_foreign_key "ertekeles_uzenet", "groups", primary_key: "grp_id", name: "fk_group_id", on_delete: :cascade
  add_foreign_key "ertekeles_uzenet", "users", column: "felado_usr_id", primary_key: "usr_id", name: "fk_felado_usr_id", on_delete: :nullify
  add_foreign_key "ertekelesek", "ertekelesek", column: "next_version", name: "fk_next_version", on_delete: :nullify
  add_foreign_key "ertekelesek", "groups", column: "grp_id", primary_key: "grp_id", name: "fk807db18879696582"
  add_foreign_key "ertekelesek", "users", column: "elbiralo_usr_id", primary_key: "usr_id", name: "fk807db188b31cf015"
  add_foreign_key "ertekelesek", "users", column: "felado_usr_id", primary_key: "usr_id", name: "fk807db18871c0d156"
  add_foreign_key "groups", "groups", column: "grp_parent", primary_key: "grp_id", name: "$1", on_update: :cascade, on_delete: :nullify
  add_foreign_key "grp_membership", "groups", column: "grp_id", primary_key: "grp_id", name: "grp_membership_grp_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "grp_membership", "users", column: "usr_id", primary_key: "usr_id", name: "grp_membership_usr_id_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "im_accounts", "users", column: "usr_id", primary_key: "usr_id", name: "im_accounts_usr_id_fkey"
  add_foreign_key "log", "groups", column: "grp_id", primary_key: "grp_id", name: "log_group", on_update: :cascade, on_delete: :cascade
  add_foreign_key "log", "users", column: "usr_id", primary_key: "usr_id", name: "log_user", on_update: :cascade, on_delete: :cascade
  add_foreign_key "lostpw_tokens", "users", column: "usr_id", primary_key: "usr_id", name: "fk1e9df02e5854b081"
  add_foreign_key "point_history", "users", column: "usr_id", primary_key: "usr_id", name: "point_history_usr_id_fkey"
  add_foreign_key "pontigenyles", "ertekelesek", column: "ertekeles_id", name: "fk_ertekeles_id", on_delete: :cascade
  add_foreign_key "pontigenyles", "users", column: "usr_id", primary_key: "usr_id", name: "fkaa1034cd6958e716"
  add_foreign_key "poszt", "grp_membership", column: "grp_member_id", name: "poszt_grp_member_fk", on_update: :cascade, on_delete: :cascade
  add_foreign_key "poszt", "poszttipus", column: "pttip_id", primary_key: "pttip_id", name: "poszt_pttip_fk", on_update: :cascade, on_delete: :cascade
  add_foreign_key "poszttipus", "groups", column: "grp_id", primary_key: "grp_id", name: "poszttipus_opc_csoport", on_update: :cascade, on_delete: :cascade
  add_foreign_key "users", "grp_membership", column: "usr_svie_primary_membership", name: "users_main_group_fkey"
  add_foreign_key "usr_private_attrs", "users", column: "usr_id", primary_key: "usr_id", name: "usr_private_attrs_usr_id_fkey"
end
