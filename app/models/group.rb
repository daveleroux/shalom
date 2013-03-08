class Group < ActiveRecord::Base
  attr_accessible :name

  def addParty(party)
    if (!parties.include? party)
      parties << party
    end
  end

  has_and_belongs_to_many :parties
end
