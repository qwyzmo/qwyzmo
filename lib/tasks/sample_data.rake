
namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		make_users
	end
end

def make_users
	admin = User.create!(name:									"admin",
											 email:									"a@q.com",
											 password: 							"asdfasdf",
											 password_confirmation: "asdfasdf",
											 admin: true,
											 status: User::STATUS[:activated]
											 )
	10.times do |n|
		name	= Faker::Name.name
		email = "u-#{n+1}@q.com"
		password	= "asdfasdf"
		User.create!(name:		 name,
								 email:		 email,
								 password: password,
								 password_confirmation: password,
								 status: User::STATUS[:activated]
								 )
	end
end
