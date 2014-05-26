
class FeedbackController < ApplicationController
	
	def send_feedback
		user_id = current_user.nil? ? nil : current_user.id
		FeedbackMailer.feedback_email(user_id, request.remote_ip, 
				request.referer, request.env['HTTP_USER_AGENT'],
				params[:feedback]).deliver
		flash[:success] = "Thanks for your feedback"
		email = ActionMailer::Base.deliveries.last
		redirect_to :back
	end
	
end