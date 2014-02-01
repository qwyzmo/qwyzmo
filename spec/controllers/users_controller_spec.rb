require 'spec_helper'

describe UsersController do
	render_views
	
	describe "access control" do
		
		describe "when not logged in" do
			it "denies access to show" do
				get :show, id: 1
				expect(response).to redirect_to(signin_path)
			end
			
			it "denies access to edit" do
				get :edit, id: 1
				expect(response).to redirect_to(signin_path)
			end
			
			it "denies acces to update" do
				get :update, id: 1
				expect(response).to redirect_to(signin_path)
			end
			
			it "denies access to edit_password" do
				get :edit_password, id: 1
				expect(response).to redirect_to(signin_path)
			end
		end
		
		describe "when logged in as wrong user" do
			before do
				@right_user = FactoryGirl.create(:user)
				# TODO replace this with create_test_user
				@wrong_user = User.new
				
				@wrong_user.name 									= "wrong user"
				@wrong_user.email 								= "wronguser@q.com"
				@wrong_user.password 							= "passpass"
				@wrong_user.password_confirmation	= "passpass"
				@wrong_user.save!
				test_sign_in(@right_user)
			end
			
			it "denies access to show" do
				get :show, id: 2
				expect(response).to redirect_to(root_path)
			end
			
			it "denies access to edit" do
				get :edit, id: 2
				expect(response).to redirect_to(root_path)
			end
			
			it "denies access to update" do
				get :update, id: 2
				expect(response).to redirect_to(root_path)
			end
			
			it "denies access to edit_password" do
				get :edit_password, id: 2
				expect(response).to redirect_to(root_path)
			end
		end
	end # access control

	describe "#activate" do
		let(:pending_user) do
			User.new(	{	email: 'pend@q.c', 
									name: 'pending user', 
									password: "asdfasdf", 
									password_confirmation: "asdfasdf",
									status: User::STATUS[:pending_email]})
		end
	
		before do
			pending_user.save!
		end
	
		it "is successful for valid user" do
			get :activate, atok: pending_user.activation_token
			expect(response).to render_template("users/activated")
	
			saved_user = User.find(pending_user.id)
			expect(saved_user.activated?).to be_true 
		end
	
		it "fails for wrong activation token" do
			get :activate, atok: "xxxxxxx"
			expect(response).to render_template("users/activation_failed")
	
			saved_user = User.find(pending_user.id)
			expect(saved_user.pending_email?).to be_true 
		end
	end # activate

	describe "actions that require a signed in user" do
		before do
			@user = FactoryGirl.create(:user)
			test_sign_in(@user)
		end
		
		describe "#show" do
			it "renders correct template and title" do
				get :show, id: 1
				expect(response).to render_template(:show)
				expect(response.body).to have_title(@user.name)
			end
		end
		
		describe "#edit" do
			it "render correct template and title" do
				get :edit, id: 1
				expect(response).to render_template(:edit)
				expect(response.body).to have_title("Edit Account Info")
			end
		end
		
		describe "#update" do
			describe "change password" do
				it "errors if password wrong" do
					new_name = "new name"
					patch :update, {id: 1, 
													user: {	change_password: true, 
													password: 							"wrongpass",
													password_confirmation: 	"wrongpass", 
													name: 									new_name}}
					expect(response).to render_template(:edit)
					expect(response.body).to have_content("Password is incorrect")
					db_user = User.find_by(email: @user.email)
					expect(db_user.name).to_not eq new_name
				end
				
				it "changes password if successful" do
					new_name = "new name"
					patch :update, {id: 1, 
													user: {	change_password: true, 
													password: 							@user.password,
													password_confirmation: 	@user.password, 
													name: 									new_name}}
					expect(response).to redirect_to(user_path)
					db_user = User.find_by(email: @user.email)
					expect(db_user.name).to eq new_name
				end
			end
			
			it "errors if password wrong" do
				new_name = "new name"
				patch :update, {id: 1,
												user: {	change_password: false, 
												password: 							"wrongpass",
												password_confirmation: 	"wrongpass", 
												name: 									new_name}}
				expect(response).to render_template(:edit)
				expect(response.body).to have_content("Password is incorrect")
				db_user = User.find_by(email: @user.email)
				expect(db_user.name).to_not eq new_name
			end
			
			describe "in conflict with another user" do
				before do
					# TODO replace this with create_test_user
					@other_user = User.new
					@other_user.name 									= "other name"
					@other_user.email 									= "wronguser@q.com"
					@other_user.password 							= "passpass"
					@other_user.password_confirmation	= "passpass"
					@other_user.save!
				end
					
				it "fails if name taken" do
					patch :update, {id: 1,
													user: {	change_password: false, 
													email:									@user.email,
													password: 							@user.password,
													password_confirmation: 	@user.password, 
													name: 									@other_user.name}}
					expect(response).to render_template(:edit)
					expect(response.body).to have_content("Name has already been taken")
					db_user = User.find_by(email: @user.email)
					expect(db_user.name).to_not eq @other_user.name
				end
				
				it "fails if email taken" do
					patch :update, {id: 1,
													user: {	change_password: false, 
													email:									@other_user.email,
													password: 							@user.password,
													password_confirmation: 	@user.password, 
													name: 									@user.name}}
					expect(response).to render_template(:edit)
					expect(response.body).to have_content("Email has already been taken")
					db_user = User.find_by(email: @user.email)
					expect(db_user.email).to_not eq @other_user.email
				end
			end

			it "renders correct template and message on success" do
				new_email = "new.email@q.com"
				new_name  = "new name"
				patch :update, {id: 1,
												user: {	change_password: false, 
												email:									new_email,
												password: 							@user.password,
												password_confirmation: 	@user.password, 
												name: 									new_name}}
				expect(response).to redirect_to(@user)
				db_user = User.find(1)
				expect(db_user.email).to eq new_email
				expect(db_user.name).to eq new_name
			end
		end # update
	end # actions that require signed in user
	
	describe "#create" do
		it "on failure, render new with errors" do
			count = User.count
			get :create, { user: {
												email:									"new@q.com",
												password: 							"passpass",
												password_confirmation: 	"passpass", 
												name: 									""}}
			expect(response).to render_template(:new)
			expect(response.body).to have_content("Name can't be blank")
			expect(User.count).to eq(count)
		end
		
		it "on success, render checkemail" do
			count = User.count
			get :create, { user: {
												email:									"new@q.com",
												password: 							"passpass",
												password_confirmation: 	"passpass", 
												name: 									"new name"}}
			expect(response).to render_template(:checkemail)
			expect(response.body).to have_content("Please check your email")
			expect(User.count).to eq(count + 1)
		end
	end # create

	describe "#new" do
		it "render correct template and title" do
			get :new
			expect(response).to render_template(:new)
			expect(response.body).to have_title("Sign up")
		end
	end
	
	describe "password actions" do
		let(:reset_user) do
			User.new(	{	email: 'reset@me.now', 
									name: 'reset me now', 
									password: "asdfasdf", 
									password_confirmation: "asdfasdf"})
		end
		
		describe "#forgot_password" do
			it "renders correct template and title" do
				get :forgot_password
				expect(response).to render_template(:forgot_password)
				expect(response.body).to have_title("Get reset password link")
			end
		end
		
		describe "#edit_password" do
			it "renders correct template and title" do
				user =  FactoryGirl.create(:user)
				test_sign_in(user)
				get :edit_password, id: 1
				expect(response).to render_template(:edit_password)
				expect(response.body).to have_title("Change Password")
			end
		end
		
		describe "#send_reset_link" do
			before do
				reset_user.save!
			end
	
			it "fails for the wrong email address" do
				get :send_reset_link, email: 'wrong@email.address'
				email = ActionMailer::Base.deliveries.last
				expect(email).to be_nil
				expect(response).to redirect_to(forgot_password_path)
				saved_user = User.find(reset_user.id)
				expect(saved_user.password_reset_token).to be_nil
				expect(saved_user.password_reset_token_date
							).to be_nil
			end
			
			it "sends you to reset notification page with valid email" do
				get :send_reset_link, email: reset_user.email
				email = ActionMailer::Base.deliveries.last
				expect(email).to_not be_nil
				expect(response).to render_template("users/reset_sent")
				saved_user = User.find(reset_user.id)
				expect(saved_user.password_reset_token).to_not be_nil
				expect(saved_user.password_reset_token_date
							).to_not be_nil
				ActionMailer::Base.deliveries.clear
			end
		end # send reset link
		
		describe "#get_reset_password" do
			before do
				reset_user.update_attribute( 
						:password_reset_token, SecureRandom.uuid)
			end
			
			it "fails on bad token" do
				reset_user.update_attribute( 
						:password_reset_token_date, DateTime.now )
				get :get_reset_password, 
						UsersController::RESET_PASS_TOKEN_NAME => "bad-token"
				expect(response).to render_template("users/pass_token_invalid") 
			end
			
			it "fails on old token" do
				reset_user.update_attribute( 
						:password_reset_token_date, DateTime.now - 1 )
				get :get_reset_password, 
						UsersController::RESET_PASS_TOKEN_NAME => reset_user.password_reset_token
				expect(response).to render_template("users/pass_token_invalid")
			end
			
			it "renders get_reset_password page with good token" do
				reset_user.update_attribute( 
						:password_reset_token_date, DateTime.now )
				get :get_reset_password, 
						UsersController::RESET_PASS_TOKEN_NAME => reset_user.password_reset_token
				expect(response).to render_template("users/get_reset_password")
			end
		end

		describe "#reset_password" do
			before do
				reset_user.save!
				@original_pass_digest = reset_user.password_digest
				@user = User.create_password_reset_token(reset_user.email)
			end

			
			it "fails if username not found" do
				post	:reset_password, user: {
							name: 									"invalid",
							password: 							reset_user.password,
							password_confirmation: 	reset_user.password,
							password_reset_token:		@user.password_reset_token }
				expect_err_back_to_get_reset_password
			end

			it "fails if token doesnt match database" do
				post	:reset_password, user: {
							name: 									@user.name,
							password: 							reset_user.password,
							password_confirmation: 	reset_user.password,
							password_reset_token:		"invalid" }
				expect_err_back_to_forgot_password
			end

			it "fails if token is expired" do
				@user.update_attribute(:password_reset_token_date, DateTime.now - 1)
				post	:reset_password, user: {
							name: 									@user.name,
							password: 							reset_user.password,
							password_confirmation: 	reset_user.password,
							password_reset_token:		@user.password_reset_token }
				expect_err_back_to_forgot_password
			end

			it "fails if password and password confirmation do not match" do
				post	:reset_password, user: {
							name: 									@user.name,
							password: 							reset_user.password,
							password_confirmation: 	"mismatched",
							password_reset_token:		@user.password_reset_token }
				expect_err_back_to_get_reset_password
			end
			
			it "fails if password invalid" do
				post	:reset_password, user: {
							name: 									@user.name,
							password: 							"2short",
							password_confirmation: 	"2short",
							password_reset_token:		@user.password_reset_token }
				expect_err_back_to_get_reset_password
			end
			
			it "on success: renders show, saves pass, shows reset message" do
				post	:reset_password, user: {
							name: 									@user.name,
							password: 							reset_user.password,
							password_confirmation: 	reset_user.password,
							password_reset_token:		@user.password_reset_token }
				expect(response).to render_template('users/show')
				expect(response.body).to have_content("Your password has been saved")
				db_user = User.find(reset_user.id)
				expect(db_user.password_digest).to_not eq(@original_pass_digest)
				expect(response.body).to have_content("Sign out")
				expect(response.body).to have_title(@user.name)
			end
			
			def expect_err_back_to_get_reset_password
				expect(response).to render_template('users/get_reset_password')
				expect(response.body).to have_css("div#error_explanation")
				db_user = User.find(reset_user.id)
				expect(db_user.password_digest).to eq(@original_pass_digest)
				expect(response.body).to have_xpath(
							"//input[@value='#{@user.password_reset_token}']")
			end
			
			def expect_err_back_to_forgot_password
				expect(response).to render_template('users/forgot_password')
				expect(response.body).to have_content("Password reset token invalid")
				db_user = User.find(reset_user.id)
				expect(db_user.password_digest).to eq(@original_pass_digest)
			end
		end # #reset password
	end # password reset actions
end # users controller














