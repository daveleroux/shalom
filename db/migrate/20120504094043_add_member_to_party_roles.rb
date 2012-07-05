class AddMemberToPartyRoles < ActiveRecord::Migration
  def change
    add_column :party_roles, :member, :boolean
  end
end
