class PartyRole < ActiveRecord::Base
  attr_accessible :party_id
  belongs_to :party
end
