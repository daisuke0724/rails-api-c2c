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

ActiveRecord::Schema[7.0].define(version: 2023_01_28_075652) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "user_list_items", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.decimal "point"
    t.bigint "user_purchase_items_id"
    t.integer "lock_version", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_list_items_on_user_id"
    t.index ["user_purchase_items_id"], name: "index_user_list_items_on_user_purchase_items_id"
  end

  create_table "user_points", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.decimal "point"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_points_on_user_id"
  end

  create_table "user_purchase_items", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.decimal "point"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_purchase_items_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
  end

  add_foreign_key "user_list_items", "user_purchase_items", column: "user_purchase_items_id"
  add_foreign_key "user_list_items", "users"
  add_foreign_key "user_points", "users"
  add_foreign_key "user_purchase_items", "users"
end
