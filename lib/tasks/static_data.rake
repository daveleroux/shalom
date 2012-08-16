namespace :db do

  require 'csv'

  desc "Remove all data from database"
  task :clean => :environment do
    Rake::Task['db:reset'].invoke
  end

  task :create_admin_user do
    admin = User.create!(:username => "admin",
                         :password => "ystudent",
                         :password_confirmation => "ystudent")
    admin.toggle!(:admin)
  end

  desc "Clean, then insert admin user"
    task :clean_then_admin_user => [:clean, :create_admin_user] do
    end

  def create_staff_member(name, surname, email, cell, gender, address)
    person = Person.create!(:name => name,
                            :surname => surname,
                            :email => email,
                            :cell => cell,
                            :gender => gender)
    person.base_address = address
    StaffRole.create!({:party_id => person.id})
    person
  end

  task :create_staff do
    staffGroup = Group.create!({:name => "Staff"})
    staffGroup.parties << create_staff_member("David", "le Roux", "daveleroux@gmail.com", "27825304575", Gender::MALE, Address.create!(:address => "Mowbray"))
    #staffGroup.parties << create_staff_member("Robin", "Ho", "mailrobin2005@gmail.com", "0824042415")
    #staffGroup.parties << create_staff_member("Robin", "Ho", "mataav@yahoo.co.uk", "0824042415")
  end

  desc "Clean, then fill database with static data"
  task :fill_db => [:clean, :create_admin_user, :create_staff, :import_data] do
  end

  task :import_data do
    CSV.foreach('studenty-database.csv', :headers => true) do |row|
      firstName = row['First Name']
      surname = row['Surname']
      email = row['Email Address']
      cell = row['Contact No.']
      residenceString = row['Residence']
      roomNumber = row['Room']
      genderString = row['m/f']
      member = row['Mem']
      christianFaith = row['CF']
      bibleStudy = row['BS']
      smallEvent = row['SE']
      faculty = row['Faculty']
      extraNotes = row['extra notes']
      postGrad = row['Postgrad']


      if genderString == "f" || genderString == "m" then
        gender = genderString == "f" ? Gender::FEMALE : Gender::MALE
      else
        gender = Gender::UNKNOWN
      end


      if !cell.nil? then
        cell = cell.gsub(/\s+/, "")

        if !cell.match(/^0/) then
          cell = "0" << cell
        end

        cell = "27" << cell[1..-1]

        if cell.length != 11 then
          cell = ""
        end
      end

      res = nil

      if !residenceString.nil? then
        residenceString.downcase!
        case residenceString
          when "baxter hall"
            res = Residence::BAXTER_HALL
          when "baxter"
            res = Residence::BAXTER_HALL
          when "clarinus village"
            res = Residence::CLARINUS_VILLAGE
          when "claredon"
            res = Residence::CLARINUS_VILLAGE
          when "clarinus"
            res = Residence::CLARINUS_VILLAGE
          when "college house"
            res = Residence::COLLEGE_HOUSE
          when "college"
            res = Residence::COLLEGE_HOUSE
          when "forest hill"
            res = Residence::FOREST_HILL
          when "fuller hall"
            res = Residence::FULLER_HALL
          when "fuller"
            res = Residence::FULLER_HALL
          when "glenres"
            res = Residence::GLENRES
          when "glendower"
            res = Residence::GLENRES
          when "graca machel hall"
            res = Residence::GRACA_MACHEL_HALL
          when "graca"
            res = Residence::GRACA_MACHEL_HALL
          when "groote schuur"
            res = Residence::GROOTE_SCHUUR
          when "kilindini"
            res = Residence::KILINDINI
          when "kopano"
            res = Residence::KOPANO
          when "leo marquard"
            res = Residence::LEO_MARQUARD
          when "liesbeeck gardens"
            res = Residence::LIESBEECK_GARDENS
          when "liesbeeck"
            res = Residence::LIESBEECK_GARDENS
          when "liesbeek"
            res = Residence::LIESBEECK_GARDENS
          when "medical residence"
            res = Residence::MEDICAL_RESIDENCE
          when "obz square"
            res = Residence::OBZ_SQUARE
          when "rochester house"
            res = Residence::ROCHESTER_HOUSE
          when "rochester"
            res = Residence::ROCHESTER_HOUSE
          when "smuts hall"
            res = Residence::SMUTS_HALL
          when "smuts"
            res = Residence::SMUTS_HALL
          when "the woolsack"
            res = Residence::THE_WOOLSACK
          when "woolsack"
            res = Residence::THE_WOOLSACK
          when "tugwell hall"
            res = Residence::TUGWELL_HALL
          when "tugwell"
            res = Residence::TUGWELL_HALL
          when "university house"
            res = Residence::UNIVERSITY_HOUSE
          when "varietas"
            res = Residence::VARIETAS
        end

        if res.nil? then
          puts residenceString
        end
      end

      person = Person.create!(:name => firstName,
                              :surname => surname,
                              :email => email,
                              :cell => cell,
                              :gender => gender,)


      if !res.nil? then
        person.base_address = Res.create!(:residence => res, :room => roomNumber)
      else
        person.base_address = Address.create!(:address => residenceString)
      end

      StudentRole.create!({:party_id => person.id,
                           :faculty => faculty,
                           :member => member == 'x' ? 't' : 'f'})

      person.surveys << StandardSurvey.create!({
                                                   :investigate => christianFaith == 'x' ? 't' : 'f',
                                                   :bible_study => bibleStudy == 'x' ? 't' : 'f',
                                                   :small_event => smallEvent == 'x' ? 't' : 'f',
                                                   :notes => extraNotes,
                                               })

    end
  end
end