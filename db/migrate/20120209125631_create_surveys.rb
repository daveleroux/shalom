class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.integer :party_id
      t.string :name
      t.timestamps
    end

    add_index :surveys, :party_id
  end
end
