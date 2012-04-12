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

  def create_staff_member(name, surname, email, cell, gender)
    person = Person.create!(:name => name,
                            :surname => surname,
                            :email => email,
                            :cell => cell,
                            :gender => gender)
    StaffRole.create!({:party_id => person.id})
    person
  end

  task :create_staff do
    staffGroup = Group.create!({:name => "Staff"})
    staffGroup.parties << create_staff_member("David", "le Roux", "daveleroux@gmail.com", "27825304575", Gender::MALE)
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
      addressOrRoomNumber = row['Address/Room No.']
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
      end

      if !cell.nil? && cell.match(/^0/) then
        cell = "27" << cell[1..-1]
      end

      person = Person.create!(:name => firstName,
                              :surname => surname,
                              :email => email,
                              :cell => cell,
                              :gender => gender)

      StudentRole.create!({:party_id => person.id,
                           :faculty => faculty, })

    end
  end
end