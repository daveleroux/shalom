class Party < ActiveRecord::Base
  attr_accessible :name, :notes
  attr_accessible :surname, :email, :cell, :gender #think of these fields as actually only on Person

  def partyize
    self.becomes(Party)
  end

  def getStudentRole
    party_roles.each { |role|
      if role.kind_of? StudentRole
        return role
      end
    }
    return nil
  end

  def getLastSurvey
    return surveys.length > 0 ? surveys.last : nil
  end

  def self.ransackable_attributes(auth_object = nil)
    #super & ['name', 'notes', 'surname', 'email', 'cell', 'gender', 'created_at', 'updated_at']
    super & ['name', 'notes', 'surname', 'email', 'cell', 'gender']
  end

  has_many :surveys, :dependent => :destroy
  has_many :party_roles, :dependent => :destroy
  has_one :base_address, :dependent => :destroy
  has_and_belongs_to_many :groups
end
