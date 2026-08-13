class CreateInvoiceItems < ActiveRecord::Migration[8.1]
  def change
    create_table :invoice_items, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :invoice, null: false, foreign_key: true, type: :uuid
      t.decimal :quantity, null: false, precision: 12, scale: 2
      t.text :unit, null: false
      t.bigint :price_net_cents, null: false
      t.text :vat_rate, null: false
      t.text :description, null: false

      t.timestamps
    end

    add_check_constraint :invoice_items, "vat_rate in ('23', '22', '8', '7', '5', '4', '3', '0 KR', '0 WDT', '0 EX', 'zw', 'oo', 'np I', 'np II')", name: "invoice_items_vat_rate_check"
  end
end
