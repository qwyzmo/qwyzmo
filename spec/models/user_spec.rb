require 'spec_helper'

describe User do
	before do 
		@user_params = {
				name: 									"testname", 
				email: 									"u@q.com",
				password: 							"asdfasdf", 
				password_confirmation: 	"asdfasdf"}
		@user = User.new(@user_params)
	end

	subject { @user }
	

	it { should respond_to(:name) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:authenticate) }
	it { should respond_to(:remember_token) }
	it { should respond_to(:activation_token) }
	it { should respond_to(:password_reset_token) }
	it { should respond_to(:password_reset_token_date) }
	
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
	
	describe "self.qwyz_id_to_author" do
		it "returns empty hash when qwyzlist is nil" do
			pending
		end
		
		it "returns empty hash when qwyzlist is empty hash" do
			pending
		end
		
		it "returns hash with correct name for a qwyz, given correct qwyz id" do
			pending
		end
		
		it "returns hash without qwyz id key if no qwyz has that id" do
			pending
		end
	end
	
########################### password related tests

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
	
	describe "activation token" do
		before { @user.save }
		its(:activation_token) { should_not be_blank }
	end
	
	describe "#change_password" do
		before { @user.save }
		
		describe "new password valid" do
			it "returns true" do
				is_changed = @user.change_password(@user_params,
							"qwerqwer", "qwerqwer")
				expect(is_changed).to be_true
			end
			
			it "updates the users password" do
				old_digest = @user.password_digest
				@user.change_password(@user_params, "qwerqwer", 
						"qwerqwer")
				user = User.find(@user.id)
				expect(old_digest).to_not eq user.password_digest
			end
		end

		describe "new password invalid" do
			
			it "returns false" do
				is_changed = @user.change_password(@user_params, 
						"qwerqwer", "zxc")
				expect(is_changed).to be_false
			end
			
			it "sets errors for password too short" do
				@user.change_password(@user_params, "zxc", "zxc")
				expect(@user.errors[:new_password][0]
						).to eq "must be at least 8 characters"
				expect(@user.errors[:new_password][1]
						).to be_nil
			end
			
			it "sets errors for password/confirm mismatch" do
				@user.change_password(@user_params, "qwerqwer", "zxcv1234")
				expect(@user.errors[:new_password][0]
						).to eq "must match confirmation"
			end
			
			it "leaves password unchanged" do
				old_digest = @user.password_digest
				@user.change_password(@user_params, "qwerqwer", 
						"zxc")
				user = User.find(@user.id)
				expect(old_digest.to_s).to eq(user.password_digest.to_s)
			end
		end
	end # change password

	describe "User.create_password_reset_token" do
		before { @user.save }

		it "returns user, sets token and date, with valid email" do
			test_time = DateTime.now - 5
			reset_user = User.create_password_reset_token(@user.email)
			expect(reset_user).to_not be_nil
			db_user = User.find(@user.id)
			expect(db_user.password_reset_token
						).to_not eq @user.password_reset_token
			expect(db_user.password_reset_token_date).to be > test_time
		end

		it "returns nil, doesnt set token and date with INVALID email" do
			test_time = DateTime.now - 5
			reset_user = User.create_password_reset_token("invalid@email.xxx")
			expect(reset_user).to be_nil
			db_user = User.find(@user.id)
			expect(db_user.password_reset_token
						).to eq @user.password_reset_token
			expect(db_user.password_reset_token_date
						).to eq @user.password_reset_token_date
		end
	end
	
	describe "User.find_by_password_reset_token_if_valid" do
		before do
			@user.save
		end
		
		it "returns nil if token is invalid" do
			user = User.find_by_password_reset_token_if_valid("invalid_token")
			expect(user).to be_nil
		end
		
		it "returns nil if token is older than 0.05 of a day" do
			@user.update_attribute(:password_reset_token_date, 
					DateTime.now - 0.3)
			@user.update_attribute(:password_reset_token, SecureRandom.uuid)
			user = User.find_by_password_reset_token_if_valid(
					@user.password_reset_token)
			expect(user).to be_nil
		end
		
		it "returns user if token is valid and recent" do
			@user.update_attribute(:password_reset_token_date, 
					DateTime.now - 0.02)
			@user.update_attribute(:password_reset_token, 
					SecureRandom.uuid.to_s)
			user = User.find_by_password_reset_token_if_valid(
					@user.password_reset_token)
			expect(user).to_not be_nil
		end
	end
	
	describe "#password_reset_token_recent?" do
		it "returns false when password reset token to old" do
			user = User.new
			user.password_reset_token_date = DateTime.now - 0.1
			expect(user.password_reset_token_recent?).to be_false
		end
		
		it "returns true when password reset token recent enough" do
			user = User.new
			user.password_reset_token_date = DateTime.now - 0.01
			expect(user.password_reset_token_recent?).to be_true
		end
	end
	
	describe "User.reset_password" do
		let(:valid_pass) { "validpassword"}
		
		before do
			@user.save
			@user = User.create_password_reset_token(@user.email)
		end

		describe "failure produces user with errors, pass unchanged" do
			it "fails with invalid name" do
				user = User.reset_password( "invalid name", valid_pass,
						valid_pass, @user.password_reset_token)
				expect(user.errors[:name][0]).to eq "is not found" 
				check_errorcount_and_db_reset_token(user)
			end

			it "fails with wrong token" do
				user = User.reset_password( @user.name, valid_pass,
						valid_pass, "invalid token")
				expect(user).to be_nil
			end
			
			it "fails if token is empty" do
				@user.update_attribute(:password_reset_token, "")
				user = User.reset_password( @user.name, valid_pass, valid_pass, "")
				expect(user).to be_nil
			end
			
			it "fails with invalid password" do
				user = User.reset_password( @user.name, "2short",
						"2short", @user.password_reset_token)
				expect(user.errors[:password][0]
						).to eq "is too short (minimum is 8 characters)"
				check_errorcount_and_db_reset_token(user)
			end
			
			it "fails with password and confirmation mismatch" do
				user = User.reset_password( @user.name, valid_pass,
						"mismatched", @user.password_reset_token)
				expect(user.errors[:password_confirmation][0]
						).to eq "doesn't match Password"
				check_errorcount_and_db_reset_token(user)
			end
			
			it "fails with expired token" do
				@user.update_attribute(:password_reset_token_date, 
						DateTime.now - 1)
				user = User.reset_password( @user.name, valid_pass,
						valid_pass, @user.password_reset_token)
				expect(user).to be_nil
			end
		end

		it "updates password on success and returns err free user" do
			user = User.reset_password( @user.name, valid_pass,
					valid_pass, @user.password_reset_token)
			expect(user.errors.messages.count).to eq 0
			db_user = User.find(@user.id)
			expect(db_user.password_digest).to_not eq @user.password_digest
			expect(db_user.password_reset_token).to be_nil
			expect(db_user.password_reset_token_date).to be_nil
		end
	end

	describe "#create_tokens" do
		class User
			def call_create_tokens
				create_tokens
			end
		end
		
		it "sets activation and remember token" do
			user = User.new
			user.status = 23424
			user.call_create_tokens
			expect(user.remember_token).to_not be_nil
			expect(user.activation_token).to_not be_nil
		end
	end
	
	describe "#password_reset_token_valid?" do
		it "returns true when tokens are equal, not empty, and recent" do
			user = User.new
			user.password_reset_token = "tok"
			user.password_reset_token_date = DateTime.now
			expect(user.password_reset_token_valid?("tok")).to be_true
		end
		
		it "returns false when tokens are empty" do
			user = User.new
			user.password_reset_token = ""
			user.password_reset_token_date = DateTime.now
			expect(user.password_reset_token_valid?("")).to be_false
		end
		
		it "returns false when tokens are not equal" do
			user = User.new
			user.password_reset_token = "token"
			user.password_reset_token_date = DateTime.now
			expect(user.password_reset_token_valid?("mismatched")).to be_false
		end
		
		it "returns false when token is old" do
			user = User.new
			user.password_reset_token = "valid"
			user.password_reset_token_date = DateTime.now - 1
			expect(user.password_reset_token_valid?("valid")).to be_false
		end
	end
	
################################ helper methods
	
	def check_errorcount_and_db_reset_token(user)
		expect(user.errors.messages.count).to eq 1
		db_user = User.find(@user.id)
		expect(db_user.password_digest).to eq @user.password_digest
	end
	
end













