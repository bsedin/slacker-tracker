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

ActiveRecord::Schema.define(version: 20170110095229) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cards", force: :cascade do |t|
    t.string   "title"
    t.jsonb    "service_ids"
    t.jsonb    "data"
    t.integer  "member_ids",                               array: true
    t.boolean  "archived",    default: false, null: false
    t.text     "description"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "tags",                                     array: true
    t.index ["member_ids"], name: "index_cards_on_member_ids", using: :gin
    t.index ["service_ids"], name: "index_cards_on_service_ids", using: :gin
    t.index ["tags"], name: "index_cards_on_tags", using: :gin
  end

  create_table "timesheets", force: :cascade do |t|
    t.integer  "card_id"
    t.integer  "user_id"
    t.integer  "time",       default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["card_id"], name: "index_timesheets_on_card_id", using: :btree
    t.index ["user_id"], name: "index_timesheets_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.jsonb    "service_ids"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "tags",                     array: true
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["name"], name: "index_users_on_name", using: :btree
    t.index ["service_ids"], name: "index_users_on_service_ids", using: :gin
    t.index ["tags"], name: "index_users_on_tags", using: :gin
  end

  add_foreign_key "timesheets", "cards"
  add_foreign_key "timesheets", "users"
end
