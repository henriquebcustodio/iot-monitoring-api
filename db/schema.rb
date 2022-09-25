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

ActiveRecord::Schema[7.0].define(version: 2022_09_25_182403) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "data_points", force: :cascade do |t|
    t.boolean "bool_value"
    t.float "numeric_value"
    t.text "text_value"
    t.datetime "timestamp", null: false
    t.bigint "variable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["variable_id"], name: "index_data_points_on_variable_id"
  end

  create_table "devices", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token"
    t.string "topic_id"
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "password_digest"
  end

  create_table "variables", force: :cascade do |t|
    t.string "name", null: false
    t.string "label", null: false
    t.text "description", null: false
    t.string "variable_type", null: false
    t.bigint "device_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_variables_on_device_id"
  end

  add_foreign_key "data_points", "variables"
  add_foreign_key "devices", "users"
  add_foreign_key "variables", "devices"
end
