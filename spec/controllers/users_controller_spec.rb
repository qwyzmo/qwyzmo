require 'spec_helper'

describe UsersController do
	render_views

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
	
	describe "password reset actions" do
		let(:reset_user) do
			User.new(	{	email: 'reset@me.now', 
									name: 'reset me now', 
									password: "asdfasdf", 
									password_confirmation: "asdfasdf"})
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
			
			def expect_err_no_reset
				expect(response).to render_template('users/get_reset_password')
				expect(response.body).to have_css("div#error_explanation")
				db_user = User.find(reset_user.id)
				expect(db_user.password_digest).to eq(@original_pass_digest)
			end
			
			it "fails if username not found" do
				post :reset_password, name: 									"invalid", 
																password: 							reset_user.password, 
																password_confirmation:	reset_user.password,
																password_reset_token:		@user.password_reset_token
				expect_err_no_reset
			end
			
			it "fails if token doesnt match database" do
				post :reset_password, name: 									@user.name, 
																password: 							reset_user.password, 
																password_confirmation:	reset_user.password,
																password_reset_token:		"invalid"
				expect_err_no_reset
			end
			
			it "fails if token is expired" do
				@user.update_attribute(:password_reset_token_date, DateTime.now - 1)
				post :reset_password, name: 									@user.name, 
																password: 							reset_user.password, 
																password_confirmation:	reset_user.password,
																password_reset_token:		@user.password_reset_token
				expect_err_no_reset
			end
			
			it "fails if password and password confirmation do not match" do
				post :reset_password, name: 									@user.name, 
																password: 							reset_user.password, 
																password_confirmation:	"mismatched",
																password_reset_token:		@user.password_reset_token
				expect_err_no_reset
			end
			
			it "fails if password invalid" do
				post :reset_password, name: 									@user.name, 
																password: 							"2short", 
																password_confirmation:	"2short",
																password_reset_token:		@user.password_reset_token
				expect_err_no_reset
			end
			
			it "on success: renders show, saves pass, shows reset message" do
				post :reset_password, name: 									@user.name, 
																password: 							reset_user.password, 
																password_confirmation:	reset_user.password,
																password_reset_token:		@user.password_reset_token
				expect(response).to render_template('users/show')
				expect(response.body).to have_content("Your password has been saved")
				db_user = User.find(reset_user.id)
				expect(db_user.password_digest).to_not eq(@original_pass_digest)
			end
		end # #reset password
		
	end # password reset actions
end # users controller














