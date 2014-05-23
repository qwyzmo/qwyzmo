class FeedbackMailer < ActionMailer::Base
	default from: "feedback@qwyzmo.com"
	
	FEEDBACK_EMAIL_ADDRESS = "qwyzmo.feedback@gmail.com"
	
	def feedback_email(user_id, ip, referer, feedback)
		@user_id 	= user_id
		@ip 			= ip
		@referer 	= referer
		@feedback = feedback
		domain 		= ActionMailer::Base.default_url_options[:host] 
		mail(to: FEEDBACK_EMAIL_ADDRESS, subject: "userid=#{@user_id}, ip=#{@ip}")
	end
end