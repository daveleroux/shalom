class Party < ActiveRecord::Base
  attr_accessible :name
  attr_accessible :surname, :email, :cell #think of these fields as actually only on Person

  def partyize
    self.becomes(Party)
  end

  has_many :surveys, :dependent => :destroy
  has_many :party_roles, :dependent => :destroy
  has_and_belongs_to_many :groups
end
