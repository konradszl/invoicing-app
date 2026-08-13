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

ActiveRecord::Schema[8.1].define(version: 2026_08_13_224958) do
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

  create_table "invoice_items", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description", null: false
    t.uuid "invoice_id", null: false
    t.bigint "price_net_cents", null: false
    t.decimal "quantity", precision: 12, scale: 2, null: false
    t.text "unit", null: false
    t.datetime "updated_at", null: false
    t.text "vat_rate", null: false
    t.index ["invoice_id"], name: "index_invoice_items_on_invoice_id"
    t.check_constraint "vat_rate = ANY (ARRAY['23'::text, '22'::text, '8'::text, '7'::text, '5'::text, '4'::text, '3'::text, '0 KR'::text, '0 WDT'::text, '0 EX'::text, 'zw'::text, 'oo'::text, 'np I'::text, 'np II'::text])", name: "invoice_items_vat_rate_check"
  end

  create_table "invoices", id: :uuid, default: -> { "uuidv7()" }, force: :cascade do |t|
    t.bigint "amount_gross_cents", null: false
    t.bigint "amount_net_cents", null: false
    t.bigint "amount_vat_cents", null: false
    t.bigint "amount_vat_pln_cents"
    t.text "bank_name", null: false
    t.uuid "client_id", null: false
    t.text "client_name", null: false
    t.uuid "corrects_invoice_id"
    t.string "country_code", limit: 2, null: false
    t.datetime "created_at", null: false
    t.string "currency", limit: 3, null: false
    t.text "document_type", null: false
    t.decimal "exchange_rate", precision: 12, scale: 6
    t.date "exchange_rate_date"
    t.text "iban", null: false
    t.text "invoice_number", null: false
    t.date "issue_date", null: false
    t.text "issue_place", null: false
    t.uuid "organization_id", null: false
    t.date "paid_at"
    t.date "payment_due_date", null: false
    t.text "payment_method", null: false
    t.text "postal_code", null: false
    t.date "sale_date", null: false
    t.text "status", null: false
    t.text "street", null: false
    t.text "street_number", null: false
    t.text "swift_code", null: false
    t.text "tax_number", null: false
    t.text "town", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_invoices_on_client_id"
    t.index ["corrects_invoice_id"], name: "index_invoices_on_corrects_invoice_id"
    t.index ["organization_id", "invoice_number"], name: "index_invoices_on_organization_id_and_invoice_number", unique: true
    t.index ["organization_id"], name: "index_invoices_on_organization_id"
    t.check_constraint "(currency::text <> 'PLN'::text) = (exchange_rate_date IS NOT NULL)", name: "invoices_exchange_rate_date_check"
    t.check_constraint "(currency::text = 'PLN'::text) = (exchange_rate IS NULL)", name: "invoices_exchange_rate_check"
    t.check_constraint "country_code::text ~ '^[A-Z]{2}$'::text", name: "invoices_country_code_check"
    t.check_constraint "currency::text ~ '^[A-Z]{3}$'::text", name: "invoices_currency_check"
    t.check_constraint "document_type = ANY (ARRAY['invoice'::text, 'corrective invoice'::text])", name: "invoices_document_type_check"
    t.check_constraint "payment_due_date >= issue_date", name: "invoices_payment_due_date_check"
    t.check_constraint "status = ANY (ARRAY['draft'::text, 'issued'::text, 'paid'::text, 'corrected'::text, 'cancelled'::text])", name: "invoices_status_check"
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
    t.text "bank_name"
    t.datetime "created_at", null: false
    t.text "iban"
    t.text "organization_name", null: false
    t.text "swift_code"
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
  add_foreign_key "invoice_items", "invoices"
  add_foreign_key "invoices", "clients"
  add_foreign_key "invoices", "invoices", column: "corrects_invoice_id"
  add_foreign_key "invoices", "organizations"
  add_foreign_key "memberships", "organizations"
  add_foreign_key "memberships", "users"
  add_foreign_key "sessions", "users"
end
