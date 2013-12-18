class SessionsController < ApplicationController
	def new
		puts "-=-=-=-=->> sessions controller new"
		@title = "Sign in"
	end

  def create
  	puts "()()()()()>> sessions controller create"
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
    	puts "-----> user authenticated"
      sign_in user
      redirect_back_or user
    else
    	puts "-----> user NOT authenticated"
      flash.now[:error] = 'Invalid email/password combination'
      @title = "Sign in"
      render 'new'
    end
  end

	# def create
		# user = User.authenticate(params[:session][:email],params[:session][:password])
		# if user.nil? || user.deactivated?
			# flash.now[:error] = user.nil? ? "Invalid email/password combination." 
				# : "Your account has been deactivated."
			# @title = "Sign in"
			# render 'new'
		# else
			# sign_in user
			# redirect_back_or user
		# end
	# end

	def destroy
		sign_out
		redirect_to root_path
	end

end
