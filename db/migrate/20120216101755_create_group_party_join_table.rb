class CreateGroupPartyJoinTable < ActiveRecord::Migration
  def change
    create_table :groups_parties, :id => false do |t|
      t.integer :group_id
      t.integer :party_id
    end
  end
  end
