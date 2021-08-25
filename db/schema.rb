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

ActiveRecord::Schema.define(version: 2021_08_17_003724) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "fields", force: :cascade do |t|
    t.string "name", null: false
    t.string "code"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_fields_on_code", unique: true
    t.index ["name"], name: "index_fields_on_name", unique: true
  end

  create_table "holidays", force: :cascade do |t|
    t.string "name"
    t.date "date", null: false
    t.bigint "monthly_forecast_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["date"], name: "index_holidays_on_date", unique: true
    t.index ["monthly_forecast_id"], name: "index_holidays_on_monthly_forecast_id"
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

  create_table "member_forecasts", force: :cascade do |t|
    t.bigint "member_id", null: false
    t.bigint "team_id", null: false
    t.bigint "monthly_forecast_id", null: false
    t.jsonb "hours"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["member_id"], name: "index_member_forecasts_on_member_id"
    t.index ["monthly_forecast_id", "member_id", "team_id"], name: "index_member_forecasts_on_monthly_forecast_member_and_team", unique: true
    t.index ["monthly_forecast_id"], name: "index_member_forecasts_on_monthly_forecast_id"
    t.index ["team_id"], name: "index_member_forecasts_on_team_id"
  end

  create_table "member_roles", force: :cascade do |t|
    t.bigint "role_id", null: false
    t.bigint "member_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["member_id"], name: "index_member_roles_on_member_id"
    t.index ["role_id"], name: "index_member_roles_on_role_id"
  end

  create_table "members", force: :cascade do |t|
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.string "email", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_members_on_email", unique: true
    t.index ["last_name", "middle_name", "first_name"], name: "index_members_on_last_name_and_middle_name_and_first_name", unique: true
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "member_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["member_id"], name: "index_memberships_on_member_id"
    t.index ["team_id"], name: "index_memberships_on_team_id"
  end

  create_table "monthly_forecasts", force: :cascade do |t|
    t.date "date", null: false
    t.integer "work_hours", default: 0, null: false
    t.integer "holiday_hours", default: 0, null: false
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

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_teams_on_name", unique: true
    t.index ["slug"], name: "index_teams_on_slug", unique: true
  end

  add_foreign_key "holidays", "monthly_forecasts"
  add_foreign_key "mail_histories", "mail_jobs"
  add_foreign_key "mail_jobs", "teams"
  add_foreign_key "member_forecasts", "members"
  add_foreign_key "member_forecasts", "monthly_forecasts"
  add_foreign_key "member_forecasts", "teams"
  add_foreign_key "member_roles", "members"
  add_foreign_key "member_roles", "roles"
  add_foreign_key "memberships", "members"
  add_foreign_key "memberships", "teams"
  add_foreign_key "team_fields", "fields"
  add_foreign_key "team_fields", "teams"
end
