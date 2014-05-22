
class FeedbackController < ApplicationController
	
	def send_feedback
		user_id = current_user.nil? ? nil : current_user.id
		puts "===========>>> user_id							= #{user_id}"
		puts "===========>>> user ip 						 	= #{request.remote_ip}"
		puts "===========>>> from page						= #{request.referer}"
		puts "===========>>> feedback 						= #{params[:feedback]}"
		puts "--------->> params = #{params.inspect}"
		# what to put in the feedback message: user id, ip address, what page they are on.
		flash[:success] = "Thanks for your feedback"
		
		redirect_to :back
	end
	
end