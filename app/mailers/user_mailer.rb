class UserMailer < ActionMailer::Base
  default :from => "notifications@qwyzmo.com"
  
  def confirm_email(user)
    @user = user
    @url  = 'http://www.qwyzmo.com/confirm?h=12345'
    mail(to: @user.email, subject: 'Please confirm your email.')
  end
end
