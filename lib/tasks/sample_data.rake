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
											 status: User::STATUS[:activated],)
	momo = User.create!(name:										"momo",
											 email:									"m@q.com",
											 password: 							"asdfasdf",
											 password_confirmation: "asdfasdf",
											 admin: false,
											 status: User::STATUS[:activated],)
	make_qwyzs(momo)
	10.times do |n|
		name	= Faker::Name.name
		email = "u-#{n+1}@q.com"
		password	= "asdfasdf"
		User.create!(name:		 name,
								 email:		 email,
								 password: password,
								 password_confirmation: password,
								 status: User::STATUS[:activated])
	end
end

def make_qwyzs(user)
	5.times do |n|
		Qwyz.create!(	user_id:			user.id,
									name: 				"test name #{n}",
									question: 		"test question #{n}",
									description:	"test description #{n}")
	end
	3.times do |n|
		QwyzItem.create!(qwyz_id:					1,
											description:			"description #{n}",
											remote_image_url: 
					"http://res.cloudinary.com/hlxsa1nsv/image/upload/v1392832619/apekp0zrdsx29lnp80sk.jpg")
	end
end
