class UserMailer < ActionMailer::Base
  default :from => "notifications@qwyzmo.com"
  
  def confirm_email(user)
    @user = user
    domain = ActionMailer::Base.default_url_options[:host]
    @url  = "http://#{domain}/activate?" + 
    	UsersController::ACTIVATION_TOKEN_NAME + "=" +
    	@user.activation_token
    mail(to: @user.email, subject: 'Please activate your Qwyzmo account')
  end
end
