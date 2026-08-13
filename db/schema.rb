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

ActiveRecord::Schema[8.1].define(version: 2026_08_13_173415) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "clients", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.text "client_name", null: false
    t.string "country_code", limit: 2, null: false
    t.datetime "created_at", null: false
    t.uuid "organization_id", null: false
    t.text "tax_number", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id", "tax_number"], name: "index_clients_on_organization_id_and_tax_number", unique: true
    t.index ["organization_id"], name: "index_clients_on_organization_id"
    t.check_constraint "country_code::text ~ '^[A-Z]{2}$'::text", name: "clients_country_code_check"
  end

  create_table "memberships", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "organization_id", null: false
    t.text "role", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.index ["organization_id"], name: "index_memberships_on_organization_id"
    t.index ["user_id", "organization_id"], name: "index_memberships_on_user_id_and_organization_id", unique: true
    t.index ["user_id"], name: "index_memberships_on_user_id"
    t.check_constraint "role = ANY (ARRAY['owner'::text, 'admin'::text, 'member'::text])", name: "memberships_role_check"
  end

  create_table "organizations", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "organization_name", null: false
    t.text "tax_number", null: false
    t.datetime "updated_at", null: false
    t.index ["tax_number"], name: "index_organizations_on_tax_number", unique: true
  end

  create_table "sessions", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "ip_address"
    t.datetime "updated_at", null: false
    t.text "user_agent"
    t.uuid "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "email_address", null: false
    t.text "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "clients", "organizations"
  add_foreign_key "memberships", "organizations"
  add_foreign_key "memberships", "users"
  add_foreign_key "sessions", "users"
end
