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

ActiveRecord::Schema[7.0].define(version: 2023_10_04_115517) do
  create_table "accounts", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "vat_number", limit: 20
    t.string "callsign"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["callsign"], name: "index_accounts_on_callsign", unique: true
    t.index ["name"], name: "index_accounts_on_name", unique: true
  end

  create_table "projects", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "name", limit: 120, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "name"], name: "index_projects_on_account_id_and_name", unique: true
    t.index ["account_id"], name: "index_projects_on_account_id"
  end

  create_table "tasks", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tasks_on_name", unique: true
    t.index ["project_id"], name: "index_tasks_on_project_id"
  end

  add_foreign_key "projects", "accounts"
  add_foreign_key "tasks", "projects"
end
