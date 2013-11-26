require 'faker'

namespace :db do
	desc "fill database with sample data"
	task :populate => :environment do
		Rake::Task['db:reset'].invoke
		admin = User.create!(	 :name                  => "default admin",
									         :email                 => "a@q.com",
									         :password              => "ffffdddd",
									         :password_confirmation => "ffffdddd",
									         :status									 => User::STATUS[:activated] )
		admin.toggle!(:admin)
		99.times do |n|
			name = Faker::Name.name
			email = "x#{n+1}@q.com"
			password = "ffffdddd"
			User.create(	:name                   => name,
										:email                  => email,
										:password               => password,
										:password_confirmation  => password,
										:status									 => User::STATUS[:activated])
		end # create 99 users.
		User.all(:limit => 6).each do |user|
  		# create the qwyzs
  		50.times do |n|
  		  user.qwyzs.create!( :name         => "name#{n}uid=#{user.id}", 
  		                      :question     => "question#{n}", 
  		                      :description  => "description#{n}")
  		end
		end # user.all
	end # task populate
end
