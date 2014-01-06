require "spec_helper"

describe UserMailer do
	let(:user) { FactoryGirl.create(:user) }
	let(:email) { UserMailer.confirm_email(user).deliver }

	it "delivers the email" do
		# for some crazy reason, must access the email object for 
		#  this test to work.
		s = email.inspect
		deliveries_pending = ActionMailer::Base.deliveries.empty?
		expect(deliveries_pending).to be_false
	end
	
	it "is from the right address" do
		expect(email.from[0]).to eq "notifications@qwyzmo.com"
	end
		
	it "is to the right address" do
		expect(email.to[0]).to eq user.email
	end
	
	it "has the correct subject" do
		expect(email.subject).to eq(
			"Please activate your Qwyzmo account") 
	end
	
	it "has correct content" do
		expect(email).to have_content("activate your account")
	end
end
