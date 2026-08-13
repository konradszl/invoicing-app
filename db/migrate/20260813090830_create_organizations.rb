class CreateOrganizations < ActiveRecord::Migration[8.1]
  def change
    create_table :organizations, id: :uuid, default: -> { "uuidv7()" }  do |t|
      t.text :organization_name, null: false
      t.text :tax_number, null: false

      t.timestamps
    end

    add_index :organizations, :tax_number, unique: true
  end
end
