class AddSurnameToParties < ActiveRecord::Migration
  def change
    add_column :parties, :surname, :string
  end
end
