require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:name => "Grace Follower",
                         :email => "miraculous@turnarounds.org",
                         :password => "abcdef",
                         :password_confirmation => "abcdef")
    admin.toggle!(:admin)
    99.times do |n|
      name = Faker::Name.name
      email = "miraculous-#{n+1}@turnarounds.org"
      password = "password"
      User.create!(:name => name,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
    end
    User.all(:limit => 6).each do |user|
      50.times do
        user.microposts.create!(:content => Faker::Lorem.sentence(5))
      end
    end
  end
end 
