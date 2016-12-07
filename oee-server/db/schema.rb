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

ActiveRecord::Schema.define(version: 20161207081822) do

  create_table "areas", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "asset_balance_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "fix_asset_track_id"
    t.datetime "cap_date"
    t.string   "profit_center"
    t.string   "asset_description"
    t.float    "acquis_val",            limit: 24
    t.float    "accum_dep",             limit: 24
    t.float    "book_val",              limit: 24
    t.string   "asset_class"
    t.string   "inventory_nr"
    t.string   "ts_equipment_nr"
    t.string   "ts_project"
    t.string   "ts_inventory_user_id"
    t.string   "ts_keeper"
    t.string   "ts_position"
    t.string   "ts_nameplate_track"
    t.string   "ts_type"
    t.string   "ts_equipment_type"
    t.string   "ts_area_id"
    t.string   "ts_supplier"
    t.string   "status"
    t.string   "remark"
    t.string   "ts_inventory_result"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "asset_balance_list_id"
    t.string   "lock_user_id"
    t.string   "lock_remark"
    t.datetime "lock_at"
    t.integer  "lock_batch",                       default: 0
    t.boolean  "locked",                           default: false
    t.boolean  "is_move",                          default: false
    t.index ["asset_balance_list_id"], name: "index_asset_balance_items_on_asset_balance_list_id", using: :btree
    t.index ["fix_asset_track_id"], name: "index_asset_balance_items_on_fix_asset_track_id", using: :btree
    t.index ["locked"], name: "index_asset_balance_items_on_locked", using: :btree
  end

  create_table "asset_balance_lists", id: :string, limit: 36, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "balance_date"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["id"], name: "index_asset_balance_lists_on_id", using: :btree
  end

  create_table "attachments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "path"
    t.string   "size"
    t.string   "type"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "bu_mangers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "nr"
    t.string   "name"
    t.string   "finance_nr"
    t.string   "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "budget_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "qty"
    t.float    "unit_price",  limit: 24
    t.float    "total_price", limit: 24
    t.integer  "budget_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["budget_id"], name: "index_budget_items_on_budget_id", using: :btree
  end

  create_table "budgets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "code"
    t.integer  "type"
    t.string   "desc"
    t.integer  "capex_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["capex_id"], name: "index_budgets_on_capex_id", using: :btree
  end

  create_table "bus", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "nr"
    t.string   "name"
    t.string   "finance_nr"
    t.string   "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "capexes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "project"
    t.integer  "bu_code"
    t.string   "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "crafts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "nr"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "departments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "nr"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.float    "target",      limit: 24, default: 0.0
  end

  create_table "downtime_codes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "nr"
    t.integer  "downtime_type_id"
    t.string   "description"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["downtime_type_id"], name: "index_downtime_codes_on_downtime_type_id", using: :btree
  end

  create_table "downtime_data", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "fors_werk"
    t.string   "fors_faufnr"
    t.string   "fors_faufpo"
    t.string   "fors_lnr"
    t.string   "fors_einres"
    t.string   "pk_sch"
    t.datetime "pk_datum"
    t.string   "pk_sch_std"
    t.string   "pk_sch_t"
    t.string   "pd_prod_nr"
    t.float    "pd_teb",        limit: 24
    t.float    "pd_stueck",     limit: 24
    t.float    "pd_auss_ruest", limit: 24
    t.float    "pd_auss_prod",  limit: 24
    t.string   "pd_bemerk"
    t.string   "pd_user"
    t.datetime "pd_erf_dat"
    t.datetime "pd_von"
    t.datetime "pd_bis"
    t.string   "pd_stoer"
    t.float    "pd_std",        limit: 24
    t.integer  "pd_laenge"
    t.string   "pd_rf"
    t.boolean  "is_naturl"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "downtime_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "fors_werk"
    t.string   "fors_faufnr"
    t.string   "fors_faufpo"
    t.string   "fors_lnr"
    t.integer  "machine_id"
    t.string   "pk_sch"
    t.datetime "pk_datum"
    t.string   "pk_sch_std"
    t.string   "pk_sch_t"
    t.integer  "craft_id"
    t.float    "pd_teb",             limit: 24
    t.float    "pd_stueck",          limit: 24
    t.float    "pd_auss_ruest",      limit: 24
    t.float    "pd_auss_prod",       limit: 24
    t.string   "pd_bemerk"
    t.string   "pd_user"
    t.datetime "pd_erf_dat"
    t.datetime "pd_von"
    t.datetime "pd_bis"
    t.integer  "downtime_code_id"
    t.float    "pd_std",             limit: 24
    t.integer  "pd_laenge"
    t.string   "pd_rf"
    t.boolean  "is_naturl",                     default: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.float    "standard_work_time", limit: 24, default: 0.0
    t.integer  "monthly"
    t.index ["craft_id"], name: "index_downtime_records_on_craft_id", using: :btree
    t.index ["downtime_code_id"], name: "index_downtime_records_on_downtime_code_id", using: :btree
    t.index ["machine_id"], name: "index_downtime_records_on_machine_id", using: :btree
  end

  create_table "downtime_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "nr"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "equipment_depreciations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "depreciation_time"
    t.float    "original_val",       limit: 24
    t.float    "depreciation_val",   limit: 24
    t.float    "net_val",            limit: 24
    t.integer  "equipment_track_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["equipment_track_id"], name: "index_equipment_depreciations_on_equipment_track_id", using: :btree
  end

  create_table "equipment_releases", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "equipment_track_id"
    t.integer  "release_index"
    t.datetime "release_time"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "remark"
    t.string   "reason"
    t.string   "report"
    t.string   "user_id"
    t.index ["equipment_track_id"], name: "index_equipment_releases_on_equipment_track_id", using: :btree
  end

  create_table "equipment_statuses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "desc"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "group_id",   default: 100
  end

  create_table "equipment_tracks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "level"
    t.string   "name"
    t.string   "nr"
    t.integer  "type"
    t.string   "asset_nr"
    t.string   "description"
    t.string   "product_id"
    t.string   "equipment_serial_id"
    t.string   "supplier"
    t.string   "profit_center"
    t.string   "department"
    t.string   "project"
    t.string   "location"
    t.string   "ts_area_id"
    t.string   "position"
    t.datetime "cap_date"
    t.float    "release_cycle",       limit: 24, default: 0.0
    t.datetime "next_release"
    t.string   "release_notice"
    t.string   "asset_bu_id"
    t.string   "remark"
    t.boolean  "is_top",                         default: true
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "operate_instructor"
    t.string   "maintain_instructor"
    t.integer  "status",                         default: 6
    t.string   "asset_class"
    t.integer  "inventory_user_id"
    t.string   "keeper"
    t.string   "nameplate_track"
    t.string   "ts_type"
    t.string   "ts_equipment_type"
    t.string   "inventory_result"
    t.string   "process_params"
    t.string   "maintain_plan"
    t.string   "machine_down"
    t.string   "big_maintain_plan"
    t.string   "instruction"
    t.string   "replacement_list"
    t.string   "ancestry"
    t.integer  "equip_create_way"
    t.string   "rfid_nr"
    t.index ["ancestry"], name: "index_equipment_tracks_on_ancestry", using: :btree
  end

  create_table "fix_asset_tracks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "info_receive_date"
    t.string   "apply_id"
    t.string   "description"
    t.float    "qty",                limit: 24
    t.float    "price",              limit: 24
    t.string   "proposer"
    t.string   "procurment_id"
    t.datetime "procurment_date"
    t.string   "supplier"
    t.string   "project"
    t.string   "completed_id"
    t.boolean  "is_add_equipment",              default: false
    t.string   "equipment_nr"
    t.boolean  "is_add_fix_asset",              default: false
    t.string   "nr"
    t.integer  "status",                        default: 100
    t.string   "remark"
    t.integer  "equipment_track_id"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "ancestry"
    t.string   "processing_id"
    t.integer  "equip_create_way",              default: 100
    t.index ["ancestry"], name: "index_fix_asset_tracks_on_ancestry", using: :btree
  end

  create_table "holidays", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date     "holiday"
    t.integer  "type"
    t.string   "remark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inventory_files", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "path"
    t.string   "size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inventory_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "inventory_list_id"
    t.integer  "fix_asset_track_id"
    t.datetime "cap_date"
    t.string   "profit_center"
    t.string   "asset_description"
    t.float    "acquis_val",           limit: 24
    t.float    "accum_dep",            limit: 24
    t.float    "book_val",             limit: 24
    t.string   "ts_equipment_nr"
    t.string   "ts_project"
    t.string   "ts_inventory_user_id"
    t.string   "ts_keeper"
    t.string   "ts_position"
    t.string   "ts_nameplate_track"
    t.string   "ts_type"
    t.string   "ts_equipment_type"
    t.string   "ts_area_id"
    t.string   "ts_supplier"
    t.string   "status"
    t.string   "remark"
    t.string   "ts_inventory_result"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.boolean  "is_cover",                        default: false
    t.string   "current_area_id"
    t.string   "current_status"
    t.string   "current_project"
    t.string   "current_nameplate"
    t.integer  "equipment_track_id"
    t.string   "rfid_nr"
    t.string   "asset_nr"
    t.string   "ancestry"
    t.index ["ancestry"], name: "index_inventory_items_on_ancestry", using: :btree
    t.index ["fix_asset_track_id"], name: "index_inventory_items_on_fix_asset_track_id", using: :btree
    t.index ["inventory_list_id"], name: "index_inventory_items_on_inventory_list_id", using: :btree
    t.index ["is_cover"], name: "index_inventory_items_on_is_cover", using: :btree
  end

  create_table "inventory_lists", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "inventory_date"
    t.string   "asset_balance_list_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "status",                default: 100
    t.index ["status"], name: "index_inventory_lists_on_status", using: :btree
  end

  create_table "machine_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "nr"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "machines", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "nr"
    t.integer  "machine_type_id"
    t.string   "oee_nr"
    t.integer  "department_id"
    t.integer  "status",          default: 100
    t.string   "remark"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["department_id"], name: "index_machines_on_department_id", using: :btree
    t.index ["machine_type_id"], name: "index_machines_on_machine_type_id", using: :btree
  end

  create_table "oauth_access_grants", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "resource_owner_id",               null: false
    t.integer  "application_id",                  null: false
    t.string   "token",                           null: false
    t.integer  "expires_in",                      null: false
    t.text     "redirect_uri",      limit: 65535, null: false
    t.datetime "created_at",                      null: false
    t.datetime "revoked_at"
    t.string   "scopes"
    t.index ["application_id"], name: "fk_rails_b4b53e07b8", using: :btree
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree
  end

  create_table "oauth_access_tokens", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",                               null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",                          null: false
    t.string   "scopes"
    t.string   "previous_refresh_token", default: "", null: false
    t.index ["application_id"], name: "fk_rails_732cb83ab7", using: :btree
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree
  end

  create_table "oauth_applications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",                                    null: false
    t.string   "uid",                                     null: false
    t.string   "secret",                                  null: false
    t.text     "redirect_uri", limit: 65535,              null: false
    t.string   "scopes",                     default: "", null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "owner_id"
    t.string   "owner_type"
    t.index ["owner_id"], name: "index_oauth_applications_on_owner_id", using: :btree
    t.index ["owner_type"], name: "index_oauth_applications_on_owner_type", using: :btree
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree
  end

  create_table "pam_info_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "nr"
    t.float    "cost",               limit: 24
    t.float    "remained",           limit: 24
    t.boolean  "is_final_approved",             default: false
    t.string   "in_process"
    t.string   "approved"
    t.string   "budget_not_applied"
    t.integer  "budget_id"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.index ["budget_id"], name: "index_pam_info_items_on_budget_id", using: :btree
  end

  create_table "pam_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "pa_no"
    t.string   "description"
    t.integer  "qty"
    t.float    "total_cost",       limit: 24
    t.string   "applicant"
    t.datetime "applicant_date"
    t.string   "supplier"
    t.string   "sap_no"
    t.string   "arrive_date"
    t.boolean  "final_release",               default: false
    t.string   "po_no"
    t.float    "po_cost",          limit: 24
    t.boolean  "invoice_prepared",            default: false
    t.float    "invoice_amount",   limit: 24
    t.string   "completed_date"
    t.string   "completed_id"
    t.string   "completed_status"
    t.float    "completed_amount", limit: 24
    t.boolean  "booking_status",              default: false
    t.float    "final_cost",       limit: 24
    t.integer  "pam_list_id"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.index ["pam_list_id"], name: "index_pam_items_on_pam_list_id", using: :btree
  end

  create_table "pam_lists", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "nr"
    t.float    "cost",               limit: 24
    t.float    "remained",           limit: 24
    t.boolean  "is_final_approved"
    t.string   "in_process"
    t.string   "approved"
    t.string   "budget_not_applied"
    t.integer  "budget_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["budget_id"], name: "index_pam_lists_on_budget_id", using: :btree
  end

  create_table "user_area_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "area_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area_id"], name: "index_user_area_items_on_area_id", using: :btree
    t.index ["user_id"], name: "index_user_area_items_on_user_id", using: :btree
  end

  create_table "user_inventory_tasks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "inventory_list_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "type"
    t.integer  "target_qty"
    t.integer  "real_qty"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "data_file_id"
    t.integer  "error_file_id"
    t.integer  "status",            default: 100
    t.index ["data_file_id"], name: "index_user_inventory_tasks_on_data_file_id", using: :btree
    t.index ["error_file_id"], name: "index_user_inventory_tasks_on_error_file_id", using: :btree
    t.index ["inventory_list_id"], name: "index_user_inventory_tasks_on_inventory_list_id", using: :btree
    t.index ["status"], name: "index_user_inventory_tasks_on_status", using: :btree
    t.index ["user_id"], name: "index_user_inventory_tasks_on_user_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "role"
    t.integer  "is_system",              default: 0
    t.string   "email",                  default: "",  null: false
    t.string   "encrypted_password",     default: "",  null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,   null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",        default: 0,   null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "group_id",               default: 100
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
  end

  create_table "work_shifts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "nr"
    t.string   "name"
    t.time     "start_time"
    t.time     "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "work_times", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "machine_type_id"
    t.integer  "craft_id"
    t.integer  "wire_length"
    t.float    "std_time",        limit: 24
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["craft_id"], name: "index_work_times_on_craft_id", using: :btree
    t.index ["machine_type_id"], name: "index_work_times_on_machine_type_id", using: :btree
  end

  add_foreign_key "asset_balance_items", "fix_asset_tracks"
  add_foreign_key "budget_items", "budgets"
  add_foreign_key "budgets", "capexes"
  add_foreign_key "downtime_codes", "downtime_types"
  add_foreign_key "downtime_records", "crafts"
  add_foreign_key "downtime_records", "downtime_codes"
  add_foreign_key "downtime_records", "machines"
  add_foreign_key "equipment_depreciations", "equipment_tracks"
  add_foreign_key "equipment_releases", "equipment_tracks"
  add_foreign_key "inventory_items", "fix_asset_tracks"
  add_foreign_key "inventory_items", "inventory_lists"
  add_foreign_key "machines", "departments"
  add_foreign_key "machines", "machine_types"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "pam_info_items", "budgets"
  add_foreign_key "pam_items", "pam_lists"
  add_foreign_key "pam_lists", "budgets"
  add_foreign_key "user_area_items", "areas"
  add_foreign_key "user_area_items", "users"
  add_foreign_key "user_inventory_tasks", "inventory_lists"
  add_foreign_key "user_inventory_tasks", "users"
  add_foreign_key "work_times", "crafts"
  add_foreign_key "work_times", "machine_types"
end
