# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_10_23_192131) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "fields", force: :cascade do |t|
    t.string "name", null: false
    t.string "code"
    t.boolean "default", default: false, null: false
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_fields_on_code", unique: true
    t.index ["name"], name: "index_fields_on_name", unique: true
  end

  create_table "holidays", force: :cascade do |t|
    t.string "name"
    t.date "date", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["date"], name: "index_holidays_on_date", unique: true
  end

  create_table "mail_histories", force: :cascade do |t|
    t.string "identifier", null: false
    t.bigint "mail_job_id", null: false
    t.integer "type", default: 0, null: false
    t.integer "process", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["identifier"], name: "index_mail_histories_on_identifier", unique: true
    t.index ["mail_job_id"], name: "index_mail_histories_on_mail_job_id"
  end

  create_table "mail_jobs", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.bigint "team_id", null: false
    t.text "email_body"
    t.string "schedule"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_id", "name"], name: "index_mail_jobs_on_team_id_and_name", unique: true
    t.index ["team_id"], name: "index_mail_jobs_on_team_id"
  end

  create_table "member_forecast_versions", force: :cascade do |t|
    t.string "item_type"
    t.string "{:null=>false}"
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_member_forecast_versions_on_item_type_and_item_id"
  end

  create_table "member_forecasts", force: :cascade do |t|
    t.bigint "member_id", null: false
    t.bigint "team_monthly_forecast_id", null: false
    t.text "notes"
    t.jsonb "hours"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["member_id"], name: "index_member_forecasts_on_member_id"
    t.index ["team_monthly_forecast_id", "member_id"], name: "index_member_forecasts_on_team_monthly_forecast_member", unique: true
    t.index ["team_monthly_forecast_id"], name: "index_member_forecasts_on_team_monthly_forecast_id"
  end

  create_table "member_versions", force: :cascade do |t|
    t.string "item_type"
    t.string "{:null=>false}"
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_member_versions_on_item_type_and_item_id"
  end

  create_table "members", force: :cascade do |t|
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.string "email", null: false
    t.bigint "team_id"
    t.bigint "role_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_members_on_confirmation_token", unique: true
    t.index ["email"], name: "index_members_on_email", unique: true
    t.index ["last_name", "middle_name", "first_name"], name: "index_members_on_last_name_and_middle_name_and_first_name", unique: true
    t.index ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_members_on_role_id"
    t.index ["team_id"], name: "index_members_on_team_id"
  end

  create_table "monthly_forecasts", force: :cascade do |t|
    t.date "date", null: false
    t.integer "total_hours", default: 0, null: false
    t.integer "holiday_hours", default: 0, null: false
    t.text "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["date"], name: "index_monthly_forecasts_on_date", unique: true
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "team_fields", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "field_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["field_id"], name: "index_team_fields_on_field_id"
    t.index ["team_id"], name: "index_team_fields_on_team_id"
  end

  create_table "team_monthly_forecasts", force: :cascade do |t|
    t.bigint "monthly_forecast_id", null: false
    t.bigint "team_id", null: false
    t.boolean "open_for_submissions", default: true, null: false
    t.text "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["monthly_forecast_id"], name: "index_team_monthly_forecasts_on_monthly_forecast_id"
    t.index ["team_id"], name: "index_team_monthly_forecasts_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.boolean "allow_custom_fields", default: false, null: false
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_teams_on_name", unique: true
    t.index ["slug"], name: "index_teams_on_slug", unique: true
  end

  add_foreign_key "mail_histories", "mail_jobs"
  add_foreign_key "mail_jobs", "teams"
  add_foreign_key "member_forecasts", "members"
  add_foreign_key "member_forecasts", "team_monthly_forecasts"
  add_foreign_key "members", "roles"
  add_foreign_key "members", "teams"
  add_foreign_key "team_fields", "fields"
  add_foreign_key "team_fields", "teams"
  add_foreign_key "team_monthly_forecasts", "monthly_forecasts"
  add_foreign_key "team_monthly_forecasts", "teams"
end
