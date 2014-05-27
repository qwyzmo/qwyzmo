require "spec_helper"

describe FeedbackMailer do

	describe "correct feedback email sent" do
		before do
			@user_id 	= 4567
			@ip 			= "1.2.3.4"
			@referer 	= "/signin"
			@agent		= "sample agent"
			@feedback = "sample feedback 23426"
			@email = FeedbackMailer.feedback_email(
						@user_id, @ip, @referer, @agent, @feedback).deliver
		end
		
		it "delivers the email" do
			deliveries_pending = ActionMailer::Base.deliveries.empty?
			expect(deliveries_pending).to be_false
		end
		
		it "is from the right address" do
			expect(@email.from[0]).to eq "feedback@qwyzmo.com"
		end
	
		it "is to the right address" do
			expect(@email.to[0]).to eq FeedbackMailer::FEEDBACK_EMAIL_ADDRESS
		end
	
		it "has the correct subject" do
			expect(@email.subject).to eq("userid=#{@user_id}, ip=#{@ip}") 
		end
	
		it "has correct content" do
			expect(@email).to have_content(@feedback)
		end
	end
	

end