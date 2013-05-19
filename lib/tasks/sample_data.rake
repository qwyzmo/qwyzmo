require 'faker'

namespace :db do
	desc "fill database with sample data"
	task :populate => :environment do
		Rake::Task['db:reset'].invoke
		admin = User.create!(	:name => "default admin",
									:email => "admin@qwyzmo.com",
									:password => "fdfdfd",
									:password_confirmation => "fdfdfd" )
		admin.toggle!(:admin)
		99.times do |n|
			name = Faker::Name.name
			email = "example-#{n+1}@qwyzmo.com"
			password = "fakerpassword"
			User.create(	:name => name,
										:email => email,
										:password => password,
										:password_confirmation => password)
		end # 99 times
		User.all(:limit => 6).each do |user|
			50.times do
				user.microposts.create!(:content => Faker::Lorem.sentence(5))
			end
		end
	end # task populate
end
