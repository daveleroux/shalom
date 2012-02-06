namespace :db do

  desc "Remove all data from database"
  task :clean => :environment do
    Rake::Task['db:reset'].invoke
  end


  desc "Clean, then fill database with static data"
  task :static_data => :environment && :clean do
    admin = User.create!(:username => "admin",
                         :password => "ystudent",
                         :password_confirmation => "ystudent")
    admin.toggle!(:admin)
  end
end