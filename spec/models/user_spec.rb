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
				expect(old_digest.to_s
						).to eq (user.password_digest.to_s)
			end
		end
		
	end
end













