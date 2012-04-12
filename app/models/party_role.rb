class PartyRole < ActiveRecord::Base
  attr_accessible :party_id
  attr_accessible :faculty #think of these fields as actually only on StudentRole


  belongs_to :party
end
