

# by using the symbol ':user', we get factory girl to simulate the user model
Factory.define :user do |user|
	user.name										 "Momo Fitzy"
	user.email										"momo@qwyzmo.com"
	user.password								 "foobar"
	user.password_confirmation		"foobar"
end

Factory.sequence :email do |n|
	"factory-test-#{n}@example.com"
end

Factory.define :micropost do |micropost|
	micropost.content "test micropost content"
	micropost.association :user
end
