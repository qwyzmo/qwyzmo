require 'faker'

namespace :db do
	desc "fill database with sample data"
	task :populate => :environment do
		Rake::Task['db:reset'].invoke
		admin = User.create!(	:name => "example user",
									:email => "example@qwyzmo.com",
									:password => "foobar",
									:password_confirmation => "foobar" )
		admin.toggle!(:admin)
		99.times do |n|
			name = Faker::Name.name
			email = "example-#{n+1}@qwyzmo.com"
			password = "fakerpassword"
			User.create(	:name => name,
										:email => email,
										:password => password,
										:password_confirmation => password)
		end
	end
end
