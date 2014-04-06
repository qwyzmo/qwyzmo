class MailController < ApplicationController
	
	# skip_before_filter :verify_authenticity_token
	
	def receive_email
		puts "-------> received email, params = #{params.inspect}"
	end
end