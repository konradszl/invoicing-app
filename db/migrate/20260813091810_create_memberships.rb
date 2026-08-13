class CreateMemberships < ActiveRecord::Migration[8.1]
  def change
    create_table :memberships, id: :uuid, default: -> { "uuidv7()" } do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :organization, null: false, foreign_key: true, type: :uuid
      t.text :role, null: false

      t.timestamps
    end

    add_index :memberships, [ :user_id, :organization_id ], unique: true
    add_check_constraint :memberships, "role in ('owner', 'admin', 'member')", name: "memberships_role_check"
  end
end
