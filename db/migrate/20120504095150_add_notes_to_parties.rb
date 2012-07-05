class AddNotesToParties < ActiveRecord::Migration
  def change
    add_column :parties, :notes, :text
  end
end
