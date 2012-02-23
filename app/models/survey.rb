class Survey < ActiveRecord::Base
  attr_accessible :name

  belongs_to :party
end
