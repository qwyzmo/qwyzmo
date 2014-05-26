class FeedbackMailer < ActionMailer::Base
	default from: "feedback@qwyzmo.com"
	
	FEEDBACK_EMAIL_ADDRESS = "feedback.qwyzmo@gmail.com"
	
	def feedback_email(user_id, ip, referer, user_agent, feedback)
		@user_id 			= user_id
		@ip 					= ip
		@referer 			= referer
		@feedback 		= feedback
		@user_agent		= user_agent
		domain 				= ActionMailer::Base.default_url_options[:host] 
		mail(to: FEEDBACK_EMAIL_ADDRESS, subject: "userid=#{@user_id}, ip=#{@ip}")
	end
end