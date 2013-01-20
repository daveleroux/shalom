class Person < Party

  validates :cell,
            :format => {:with => /\A27\d+\Z/, :message => "must start with 27 and consist of digits (or be empty)"},
            :length => {:is => 11, :message => "must have a length of 11 (or be empty)"},
            :allow_blank => true

  validates :gender,
            :inclusion => {:in => Gender.values,
                           :message => "'%{value}' is not a valid gender"}


  def getPreferredEmail()
    email
  end

  def getPreferredCell()
    cell
  end

end