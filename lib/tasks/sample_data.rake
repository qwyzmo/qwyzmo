require 'faker'

namespace :db do
	desc "fill database with sample data"
	task :populate => :environment do
		Rake::Task['db:reset'].invoke
		admin = User.create!(	 :name                  => "default admin",
									         :email                 => "admin@qwyzmo.com",
									         :password              => "fdfdfd",
									         :password_confirmation => "fdfdfd" )
		admin.toggle!(:admin)
		99.times do |n|
			name = Faker::Name.name
			email = "example-#{n+1}@qwyzmo.com"
			password = "fakerpassword"
			User.create(	:name                   => name,
										:email                  => email,
										:password               => password,
										:password_confirmation  => password)
		end # create 99 users.
		User.all(:limit => 6).each do |user|
		  # create the microposts
			50.times do
				user.microposts.create!(:content => Faker::Lorem.sentence(5))
			end
  		# create the qwyzs
  		10.times do |n|
  		  user.qwyzs.create!( :name         => "name#{n}", 
  		                      :question     => "question#{n}", 
  		                      :description  => "description#{n}")
  		end
		end # user.all
	end # task populate
end
