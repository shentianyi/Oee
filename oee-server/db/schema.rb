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

ActiveRecord::Schema.define(version: 20160907103949) do

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
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
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

  create_table "holidays", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date     "holiday"
    t.integer  "type"
    t.string   "remark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "role"
    t.integer  "is_system",              default: 0
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
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

  add_foreign_key "downtime_codes", "downtime_types"
  add_foreign_key "downtime_records", "crafts"
  add_foreign_key "downtime_records", "downtime_codes"
  add_foreign_key "downtime_records", "machines"
  add_foreign_key "machines", "departments"
  add_foreign_key "machines", "machine_types"
  add_foreign_key "work_times", "crafts"
  add_foreign_key "work_times", "machine_types"
end
