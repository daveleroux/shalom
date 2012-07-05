class AddFieldsToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :type, :string
    add_column :surveys, :investigate, :boolean
    add_column :surveys, :bible_study, :boolean
    add_column :surveys, :small_event, :boolean
  end
end
