class AddEmailToParties < ActiveRecord::Migration
  def change
    add_column :parties, :email, :string
  end
end
