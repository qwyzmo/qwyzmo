require "spec_helper"

describe UserMailer do
	before do
		@user = FactoryGirl.create(:user)
	end
	
	describe "#confirm_email" do
		before do
			@email = UserMailer.confirm_email(@user).deliver
		end
	
		it "delivers the email" do
			deliveries_pending = ActionMailer::Base.deliveries.empty?
			expect(deliveries_pending).to be_false
		end
		
		it "is from the right address" do
			expect(@email.from[0]).to eq "notifications@qwyzmo.com"
		end
	
		it "is to the right address" do
			expect(@email.to[0]).to eq @user.email
		end
	
		it "has the correct subject" do
			expect(@email.subject).to eq(
				"Please activate your Qwyzmo account") 
		end
	
		it "has correct content" do
			expect(@email).to have_content("activate your account")
		end
	end
	
	describe "#password_reset_email" do
		before do
			User.create_password_reset_token(@user.email)
			@user = User.find(@user.id)
			@email = UserMailer.password_reset_email(@user).deliver
		end
		
		it "delivers the email" do
			deliveries_pending = ActionMailer::Base.deliveries.empty?
			expect(deliveries_pending).to be_false
		end

		it "is from the right address" do
			expect(@email.from[0]).to eq "notifications@qwyzmo.com"
		end
	
		it "is to the right address" do
			expect(@email.to[0]).to eq @user.email
		end
	
		it "has the correct subject" do
			expect(@email.subject).to eq(
				"Reset your password") 
		end
	
		it "has correct content" do
			expect(@email).to have_content("to reset your password")
		end
	end
end






