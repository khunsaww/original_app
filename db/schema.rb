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

ActiveRecord::Schema[7.1].define(version: 2026_09_02_133000) do
  create_table "dies", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "product_code", null: false
    t.string "size"
    t.string "category"
    t.bigint "location_id", null: false
    t.integer "unit_price", default: 0, null: false
    t.date "purchase_date"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "new_quantity", default: 0, null: false
    t.integer "used_quantity", default: 0, null: false
    t.index ["category"], name: "index_dies_on_category"
    t.index ["location_id"], name: "index_dies_on_location_id"
    t.index ["name"], name: "index_dies_on_name"
    t.index ["product_code"], name: "index_dies_on_product_code"
  end

  create_table "locations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_locations_on_name", unique: true
  end

  create_table "quantity_changes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "die_id", null: false
    t.bigint "user_id"
    t.integer "new_quantity_before", null: false
    t.integer "new_quantity_after", null: false
    t.integer "used_quantity_before", null: false
    t.integer "used_quantity_after", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["die_id", "created_at"], name: "index_quantity_changes_on_die_id_and_created_at"
    t.index ["die_id"], name: "index_quantity_changes_on_die_id"
    t.index ["user_id"], name: "index_quantity_changes_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0, null: false
    t.string "nickname", null: false
    t.string "encrypted_password", null: false
    t.string "last_name", null: false
    t.string "first_name", null: false
    t.string "last_name_kana", null: false
    t.string "first_name_kana", null: false
    t.date "birthday", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "dies", "locations"
  add_foreign_key "quantity_changes", "dies"
  add_foreign_key "quantity_changes", "users"
end
