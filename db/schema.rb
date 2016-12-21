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

ActiveRecord::Schema.define(version: 20161220141551) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "tasks", force: :cascade do |t|
    t.string "service_name"
    t.string "service_id"
    t.json   "data"
    t.index ["service_name", "service_id"], name: "index_tasks_on_service_name_and_service_id", unique: true, using: :btree
  end

  create_table "timesheets", force: :cascade do |t|
    t.integer "task_id"
    t.integer "user_id"
    t.integer "time",    default: 0, null: false
    t.index ["task_id"], name: "index_timesheets_on_task_id", using: :btree
    t.index ["user_id"], name: "index_timesheets_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["name"], name: "index_users_on_name", using: :btree
  end

  add_foreign_key "timesheets", "tasks"
  add_foreign_key "timesheets", "users"
end
