require 'spec_helper'

describe FeedbackController do
	before do
		@request.env['HTTP_REFERER'] = 'http://www.qwyzmo.com/qwyzs'
		@user = create_test_user("FactGirl Username", "fg@q.com", 
				"asdfasdf", "asdfasdf")
		test_sign_in(@user)
	end
	
	it "sends correct email" do
		sample_feedback = "sample feedback 24344"
		
		ActionMailer::Base.deliveries.clear
		post :send_feedback, feedback: sample_feedback
		email = ActionMailer::Base.deliveries.last
		
		expect(email).to_not be_nil
		expect(response).to redirect_to(:back)
		expect(email).to have_content(sample_feedback)
		expect(email).to have_content("user_id		=#{@user.id}")
	end
end