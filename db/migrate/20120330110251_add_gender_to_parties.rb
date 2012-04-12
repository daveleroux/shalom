class AddGenderToParties < ActiveRecord::Migration
  def change
      add_column :parties, :gender, :string
    end
end
