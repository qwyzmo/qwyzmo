class SessionsController < ApplicationController
	def new
		@title = "Sign in"
	end

	def create
		user = User.find_by(email: params[:session][:email].downcase)
		authenticated = user && user.authenticate(params[:session][:password])
		if authenticated && user.activated?
			sign_in user
			redirect_back_or user
		else
			if !authenticated
				flash.now[:error] = 'Invalid email/password combination'
			elsif user.pending_email?
				@title = "Check Email"
				@user = user
				render check_email_path
				return
			elsif user.deactivated?
				flash.now[:error] = 'Your account has been deactivated.'
			else
			end
			new
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_path
	end

end
