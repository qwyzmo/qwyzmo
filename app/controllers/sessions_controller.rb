class SessionsController < ApplicationController
	def new
		@title = "Sign in"
	end

	def create
		user = User.find_by(email: params[:session][:email].downcase)
		authenticated = user && user.authenticate(params[:session][:password])
		if authenticated && user.activated?
			sign_in user
			redirect_back_or root_path
		else
			if !authenticated
				flash.now[:error] = 'Invalid email/password combination'
			elsif user.pending_email?
				@title = "Check Email"
				@user = user
				render 'users/checkemail'
				return
			elsif user.deactivated?
				flash.now[:error] = 'Your account has been deactivated.'
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
