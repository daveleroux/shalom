namespace :db do

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

  def create_staff_member(name, surname, email, cell)
    person = Person.create!(:name => name,
                            :surname => surname,
                            :email => email,
                            :cell => cell)
    StaffRole.create!({:party_id => person.id})
    person
  end

  task :create_staff do
    staffGroup = Group.create!({:name => "Staff"})
    staffGroup.parties << create_staff_member("David", "le Roux", "daveleroux@gmail.com", "27825304575")
    #staffGroup.parties << create_staff_member("Robin", "Ho", "mailrobin2005@gmail.com", "0824042415")
    #staffGroup.parties << create_staff_member("Robin", "Ho", "mataav@yahoo.co.uk", "0824042415")
  end

  desc "Clean, then fill database with static data"
  task :static_data => [:clean, :create_admin_user, :create_staff] do
  end
end