class AddNotesToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :notes, :text
  end
end
