class AddTypeToParties < ActiveRecord::Migration
  def change
    add_column :parties, :type, :string
  end
end
