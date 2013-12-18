require 'spec_helper'

describe User do
	before do 
		@user = User.new(
				name: 									"testname", 
				email: 									"u@q.com",
				password: 							"asdfasdf", 
				password_confirmation: 	"asdfasdf") 
	end

	subject { @user }

	it { should respond_to(:name) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:authenticate) }
	it { should respond_to(:remember_token) }
	
	it { should be_valid }

	describe "when name is not present" do
		before { @user.name = " " }
		it { should_not be_valid }
	end
	
	describe "when email is not present" do
		before { @user.email = " " }
		it { should_not be_valid }
	end
	
	describe "when name is too long" do
		before { @user.name = "a" * 51 }
		it { should_not be_valid }
	end
	
	describe "when email format is invalid" do
		it "should be invalid" do
			addresses = %w[user@foo,com user_at_foo.org example.user@foo.
										 foo@bar_baz.com foo@bar+baz.com]
			addresses.each do |invalid_address|
				@user.email = invalid_address
				expect(@user).not_to be_valid
			end
		end
	end

	describe "when email format is valid" do
		it "should be valid" do
			addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
			addresses.each do |valid_address|
				@user.email = valid_address
				expect(@user).to be_valid
			end
		end
	end

	describe "when email address is already taken" do
		before do
			user_with_same_email = @user.dup
			user_with_same_email.email = @user.email.upcase
			user_with_same_email.name = "new name"
			user_with_same_email.save
		end

		it { should_not be_valid }
	end
	
	describe "when name is already taken" do
		before do
			user_with_same_name = @user.dup
			user_with_same_name.name = @user.name.upcase
			user_with_same_name.email = "different@email.com"
			user_with_same_name.save
		end
		
		it { should_not be_valid }
	end
	
	describe "when password is not present" do
		before do
			@user = User.new(name: "Example User", email: "user@example.com",
											 password: " ", password_confirmation: " ")
		end
		it { should_not be_valid }
	end
	
	describe "when password doesn't match confirmation" do
		before { @user.password_confirmation = "mismatch" }
		it { should_not be_valid }
	end
	
  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = 
    	"a" * 7 }
    it { should be_invalid }
  end
	
	describe "return value of authenticate method" do
		before { @user.save }
		let(:found_user) { User.find_by(email: @user.email) }
	
		describe "with valid password" do
			it { should eq found_user.authenticate(@user.password) }
		end
	
		describe "with invalid password" do
			let(:user_for_invalid_password) { found_user.authenticate("invalid") }
	
			it { should_not eq user_for_invalid_password }
			specify { expect(user_for_invalid_password).to be_false }
		end
	end
	
  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end
end







# describe User do
	# before(:each) do
		# @attr = {
			# :name									 => "Example User",
			# :email									=> "user@example.com",
			# :password							 => "foobar88",
			# :password_confirmation	=> "foobar88",
		# }
	# end
# 
	# it "should create a new instance given valid attributes" do
		# User.create!(@attr)
	# end
# 
	# it "should require a name" do
		# no_name_user = User.new(@attr.merge(:name => ""))
		# no_name_user.should_not be_valid
	# end
# 
	# it "should require an email address" do
		# no_email_user = User.new(@attr.merge(:email => ""))
		# no_email_user.should_not be_valid
	# end
# 
	# it "should reject names that are too long" do
		# long_name = "a" * 51
		# long_name_user = User.new(@attr.merge(:name => long_name))
		# long_name_user.should_not be_valid
	# end
# 
 	# it "should accept valid email addresses" do
		# addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
		# addresses.each do |address|
			# valid_email_user = User.new(@attr.merge!(:email => address))
			# valid_email_user.should be_valid
		# end
	# end
# 
	# it "should reject invalid email addresses" do
		# addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
		# addresses.each do |address|
			# invalid_email_user = User.new(@attr.merge(:email => address))
			# invalid_email_user.should_not be_valid
		# end
	# end
# 
	# it "should reject email addresses identical up to case" do
		# upcased_email = @attr[:email].upcase
		# User.create!(@attr.merge(:email => upcased_email))
		# user_with_duplicate_email = User.new(@attr)
		# user_with_duplicate_email.should_not be_valid
	# end
# 	
	# it "rejects names identical up to case" do
		# upcased_name = @attr[:name].upcase
		# User.create!(@attr.merge(name: upcased_name, email: "u2@ex.com"))
		# user_with_duplicate_name = User.new(@attr)
		# user_with_duplicate_name.should_not be_valid
	# end
# 
	# describe "password validations" do
# 
		# it "should require a password" do
			# User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
		# end
# 
		# it "should require a matching password confirmation" do
			# User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
		# end
# 
		# it "should reject short passwords" do
			# short = "a" * 5
			# hash = @attr.merge(:password => short, :password_confirmation => short)
			# User.new(hash).should_not be_valid
		# end
# 
		# it "should reject long passwords" do
			# long = "a" * 41
			# hash = @attr.merge(:password => long, :password_confirmation => long)
			# User.new(hash).should_not be_valid
		# end
	# end # describe password validations
# 
	# describe "password encryption" do
# 
		# before(:each) do
			# @user = User.create!(@attr)
			# @user.encrypt_save
		# end
# 
		# it "should have an encrypted password attribute" do
			# @user.should respond_to(:encrypted_password)
		# end
# 
		# it "should set the encrypted password" do
			# @user.encrypted_password.should_not be_blank
		# end
# 
		# describe "has_password? method" do
# 
			# it "should be true if the passwords match" do
				# @user.has_password?(@attr[:password]).should be_true
			# end
# 
			# it "should be false if the passwords dont match" do
				# @user.has_password?("invalid").should be_false
			# end
		# end
	# end # describe password encryption
# 
	# describe "authenticate method" do
# 
		# it "should return nil on email/password mismatch" do
			# wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
			# wrong_password_user.should be_nil
		# end
# 
		# it "should return nil for an email address with no user" do
			# nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
			# nonexistent_user.should be_nil
		# end
# 
		# it "should return the user on email/password match" do
			# matching_user = User.authenticate(@attr[:email], @attr[:password]) 
			# matching_user.should == @user
		# end
	# end # describe authenticate method
# 
	# describe "admin attribute" do
		# before(:each) do
			# @user = User.create!(@attr)
		# end
# 		
		# it "should respond to admin" do
			# @user.should respond_to(:admin)
		# end
# 		
		# it "should not be an admin by default" do
			# @user.should_not be_admin
		# end
# 		
		# it "should be convertible to an admin" do
			# @user.toggle!(:admin)
			# @user.should be_admin
		# end
	# end # describe admin attribute
# 	
	# describe "#deactivated" do
		# before(:each) do
			# @user = User.create!(@attr)
		# end
# 
		# it "is deactivated if status is deactivated" do
			# @user.status = User::STATUS[:deactivated]
			# @user.deactivated?.should == true
		# end
# 		
		# it "defaults to not deactivated" do
			# @user.deactivated?.should == false
		# end
	# end
# 
	# describe "#encrypt_save" do
		# it "should change encrypted_password field" do
			# @user = User.new(@attr)
			# new_name = "testtest234"
			# @user.name = new_name
			# before_count = User.count
			# result = @user.encrypt_save
			# after_count = User.count
			# result.should == true
			# @user.encrypted_password.should_not be_nil
			# @user.salt.should_not be_nil
			# saved = User.find @user.id
			# saved.name.should == new_name
		# end
	# end
# 
	# # TODO remove microposts
	# describe "micropost associations" do
		# before(:each) do
			# @user = User.create(@attr)
			# @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
			# @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
		# end
# 		
		# it "should have a microposts attribute" do
			# @user.should respond_to(:microposts)
		# end
# 		
		# it "should have the right microposts in the right order" do
			# @user.microposts.should == [@mp2, @mp1]
		# end
# 		
		# it "should destroy associated microposts" do
			# @user.destroy
			# [@mp1, @mp2].each do |micropost|
				# Micropost.find_by_id(micropost.id).should be_nil
			# end
		# end
# 		
		# describe "status feed" do
# 			
			# it "should have a feed" do
				# @user.should respond_to(:feed)
			# end
# 			
			# it "should have the users microposts" do
				# @user.feed.include?(@mp1).should be_true
				# @user.feed.include?(@mp2).should be_true
			# end
# 			
			# it "should not include a different users microposts" do
				# # mp3 = Factory(:micropost, :user => Factory(:user, :email => Factory.next(:email)))
				# # @user.feed.include?(mp3).should be_false
			# end
# 			
		# end # status feed
	# end #describe micropost associations
# end # describe user


