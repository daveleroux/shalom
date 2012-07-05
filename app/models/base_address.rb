class BaseAddress < ActiveRecord::Base
  #attr_accessible :party_id
  attr_accessible :address #think of these fields as actually only on Address
  attr_accessible :residence, :room #think of these fields as actually only on Res

  def baseaddressize
    self.becomes(BaseAddress)
  end

  belongs_to :party
end

