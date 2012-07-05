class Survey < ActiveRecord::Base
  attr_accessible :name, :notes
  attr_accessible :investigate, :bible_study, :small_event #think of these as on StandardSurvey


  belongs_to :party
end
