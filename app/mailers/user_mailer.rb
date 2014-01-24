class UserMailer < ActionMailer::Base
	default :from => "notifications@qwyzmo.com"
	
	def confirm_email(user)
		@user = user
		domain = ActionMailer::Base.default_url_options[:host] 
		@url = activate_url(
				UsersController::ACTIVATION_TOKEN_NAME => @user.activation_token)
		mail(to: @user.email, subject: 'Please activate your Qwyzmo account')
	end
	
	def password_reset_email(user)
		@user = user
		domain = ActionMailer::Base.default_url_options[:host]
		@url = get_reset_password_url( 
				UsersController::RESET_PASS_TOKEN_NAME => @user.password_reset_token)
		mail(to: @user.email, subject: 'Reset your password')
	end
end
