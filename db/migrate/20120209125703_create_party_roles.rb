class CreatePartyRoles < ActiveRecord::Migration
  def change
    create_table :party_roles do |t|
      t.integer :party_id

      t.timestamps
    end

    add_index :party_roles, :party_id
  end
end
