class CreateInvoices < ActiveRecord::Migration[8.1]
  def change
    create_table :invoices, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :corrects_invoice, foreign_key: { to_table: :invoices }, type: :uuid
      t.references :organization, null: false, foreign_key: true, type: :uuid
      t.references :client, null: false, foreign_key: true, type: :uuid
      t.text :document_type, null: false
      t.text :invoice_number, null: false
      t.date :sale_date, null: false
      t.date :issue_date, null: false
      t.text :issue_place, null: false
      t.text :client_name, null: false
      t.text :tax_number, null: false
      t.text :street, null: false
      t.text :street_number, null: false
      t.text :postal_code, null: false
      t.text :town, null: false
      t.string :country_code, null: false, limit: 2
      t.text :bank_name, null: false
      t.text :iban, null: false
      t.text :swift_code, null: false
      t.bigint :amount_vat_pln_cents
      t.bigint :amount_net_cents, null: false
      t.bigint :amount_gross_cents, null: false
      t.bigint :amount_vat_cents, null: false
      t.string :currency, null: false, limit: 3
      t.decimal :exchange_rate, precision: 12, scale: 6
      t.date :exchange_rate_date
      t.text :status, null: false
      t.text :payment_method, null: false
      t.date :payment_due_date, null: false
      t.date :paid_at

      t.timestamps
    end

    add_index :invoices, [ :organization_id, :invoice_number ], unique: true

    add_check_constraint :invoices, "payment_due_date >= issue_date", name: "invoices_payment_due_date_check"
    add_check_constraint :invoices, "country_code ~ '^[A-Z]{2}$'", name: "invoices_country_code_check"
    add_check_constraint :invoices, "currency ~ '^[A-Z]{3}$'", name: "invoices_currency_check"
    add_check_constraint :invoices, "status in ('draft', 'issued', 'paid', 'corrected', 'cancelled')", name: "invoices_status_check"
    add_check_constraint :invoices, "(currency = 'PLN') = (exchange_rate IS NULL)", name: "invoices_exchange_rate_check"
    add_check_constraint :invoices, "(currency != 'PLN') = (exchange_rate_date IS NOT NULL)", name: "invoices_exchange_rate_date_check"
    add_check_constraint :invoices, "document_type in ('invoice', 'corrective invoice')", name: "invoices_document_type_check"
  end
end
