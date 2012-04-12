class AddFacultyToPartyRoles < ActiveRecord::Migration
  def change
    add_column :party_roles, :faculty, :string
  end
end
