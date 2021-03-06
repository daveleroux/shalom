class BulkMailer < ActionMailer::Base
  default from: "user1@student-y.org"

  def sms (parties, content)
    @content = content;
    partiesWithCells = parties.reject { |party| party.getPreferredCell().blank? }
    partiesWithCells.collect { |party| party.getPreferredCell() }.each do |cell|
      mail(:to => cell << "@community.bulksms.com", :subject => "xxx").deliver
    end
  end

  def email (parties, subject, content)
    @content = content;
    parties.collect { |party| party.getPreferredEmail() }.each do |address|
      mail(:to => address, :subject => subject).deliver
    end
  end
end
