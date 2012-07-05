class CreateBaseAddresses < ActiveRecord::Migration
  def change
    create_table :base_addresses do |t|
      t.integer :party_id
      t.string :type
      t.string :address
      t.string :residence
      t.string :room

      t.timestamps
    end

    add_index :base_addresses, :party_id

  end
end
