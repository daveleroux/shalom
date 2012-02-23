class AddTypeToPartyRoles < ActiveRecord::Migration
  def change
    add_column :party_roles, :type, :string
  end
end
