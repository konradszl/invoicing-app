class CreateClients < ActiveRecord::Migration[8.1]
  def change
    create_table :clients, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :organization, null: false, foreign_key: true, type: :uuid
      t.text :client_name, null: false
      t.text :tax_number, null: false
      t.string :country_code, null: false, limit: 2

      t.timestamps
    end

    add_index :clients, [ :organization_id, :tax_number ], unique: true
    add_check_constraint :clients, "country_code ~ '^[A-Z]{2}$'", name: "clients_country_code_check"
  end
end
