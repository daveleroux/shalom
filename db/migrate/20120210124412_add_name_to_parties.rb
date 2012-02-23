class AddNameToParties < ActiveRecord::Migration
  def change
    add_column :parties, :name, :string
  end
end
