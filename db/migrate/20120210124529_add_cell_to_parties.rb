class AddCellToParties < ActiveRecord::Migration
  def change
    add_column :parties, :cell, :string
  end
end
