
require 'spec_helper'

describe 'password reset pages' do

	subject { page }

	describe "send reset password link page" do
		let(:user) { FactoryGirl.create(:user) }
		before do
			visit forgot_password_path
		end
		
		it "has the correct title" do
			should have_title "Get reset password link"
		end
		
		describe "valid email address sends to 'pass reset sent' page" do
			before do
				fill_in :email, with: user.email
				click_button "Send reset password link"
			end

			it "has the correct title" do
				should have_title 'Password reset link sent'
			end
			
			it "has correct content" do
				should have_content 'Please check your email'
			end

			it "sends an email" do
				email = ActionMailer::Base.deliveries.last
				expect(email).to_not be_nil
				ActionMailer::Base.deliveries.clear
			end
		end
		
		describe "for an email not in database" do
			before do
				fill_in :email, with: "wrong@email.address"
				click_button "Send reset password link"
			end
			
			it "has the title for forgot password path" do
				should have_title "Get reset password link"
			end
			
			it "has the correct error message" do
				should have_content "Email not found."
			end
			
			it "does not send an email" do
				email = ActionMailer::Base.deliveries.last
				expect(email).to be_nil
			end
		end
	end

	# TODO tests for get reset pass
	describe "get reset pass page" do
		before do
			@user = FactoryGirl.create(:user)
			@original_pass_digest = @user.password_digest
			User.create_password_reset_token(@user.email)
			@user = User.find(@user.id)
			visit get_reset_password_path + "?" + RESET_PASS_TOKEN_NAME +
					"=" + @user.password_reset_token
		end
		
		it "has the correct title" do
			should have_title "Enter new password"
		end
		
		describe "user enters correct username" do
			before do
				fill_in :name, 											with: @user.name
				fill_in :password,									with: "aabbccdd"
				fill_in :password_confirmation,	with: "aabbccdd"
				click_button "Save new password"
			end
			
			it "sends you to the show page" do
				
			end
			
			it "updates the users password" do
				
			end
		end
		
		describe "user enters wrong username" do
			
		end
	end
	
end







