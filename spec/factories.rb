	
FactoryGirl.define do
	factory :user do
		name		 							"FactGirl Username"
		email									"fg@q.com"
		password							"asdfasdf"
		password_confirmation	"asdfasdf"
	end
end

# Factory.sequence :name do |n|
	# "testname-#{n}"
# end
# 
# Factory.sequence :email do |n|
	# "factory-test-#{n}@example.com"
# end
# 
# Factory.define :qwyz do |qwyz|
	# qwyz.name "test name"
	# qwyz.question "test question"
	# qwyz.description "test description"
	# qwyz.association :user
# end
