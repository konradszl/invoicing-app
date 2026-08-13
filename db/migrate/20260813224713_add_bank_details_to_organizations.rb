class AddBankDetailsToOrganizations < ActiveRecord::Migration[8.1]
  def change
    add_column :organizations, :bank_name, :text
    add_column :organizations, :iban, :text
    add_column :organizations, :swift_code, :text
  end
end
