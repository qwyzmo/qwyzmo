class UsersController < ApplicationController

	before_action :signed_in_user, 
						only: [:show, :edit, :update, :edit_password]
	before_action :correct_user,	 
						only: [:show, :edit, :update, :edit_password]

	ACTIVATION_TOKEN_NAME = "atok"
	RESET_PASS_TOKEN_NAME = "ptok"

	def activate
		@user = User.find_by(
				activation_token: params[ACTIVATION_TOKEN_NAME])
		if @user && @user.pending_email?
			if @user.update_attribute(:status, User::STATUS[:activated])
				render 'users/activated'
				return
			end
		end
		render 'users/activation_failed'
	end

	def show
		@user = User.find(params[:id])
		@title = @user.name
	end

	def new
		@user = User.new
		@title = "Sign up"
	end

	def create
		@user = User.new(user_params)
		if @user.save
			UserMailer.confirm_email(@user).deliver
			@title = "Check Email"
			render 'users/checkemail'
		else
			render 'new'
		end
	end

	def edit
		@title = "Edit Account Info"
	end

	def update
		if params[:change_password]
			change_password
			return
		end
		updated_user = User.find_by(email: @user.email)
		if updated_user && updated_user.authenticate(user_params[:password])
			updated_params = user_params
			updated_params[:password_confirmation] = updated_params[:password]
			if @user.update_attributes(updated_params)
				flash[:success] = "Profile updated" 
				redirect_to @user
				return
			end
		else
			@user.errors.add(:password, "is incorrect.")
		end
		edit
		render 'edit'
	end
	
	# TODO refactor all password methods into a password controller
	def edit_password
		@title = "Change Password"
		@user ||= User.find(params[:id])
	end


	###################  password reset actions
	# TODO lets rename this to request_passreset
	def forgot_password
		@title = "Get reset password link"
	end
	
	# TODO lets rename this to email_passreset_link
	def send_reset_link
		@user = User.create_password_reset_token(params[:email])
		if @user
			UserMailer.password_reset_email(@user).deliver
			@title = 'Password reset link sent'
			render '/users/reset_sent'
		else
			flash[:error] = "Email not found."
			redirect_to forgot_password_path
		end
	end
	
	def get_reset_password
		@user = User.find_by_password_reset_token_if_valid(
				params[RESET_PASS_TOKEN_NAME])
		if !@user
			@title = "Invalid reset password link"
			render "users/pass_token_invalid"
			return
		end
		@user.name = ""
		@title = "Enter new password"
	end
	
	def reset_password
		@user = User.reset_password(	params[:user][:name], 
																	params[:user][:password],
																	params[:user][:password_confirmation], 
																	params[:user][:password_reset_token])
		if @user.nil?
			flash[:error] = "Password reset token invalid"
			forgot_password
			render "users/forgot_password"
		elsif @user.errors.empty?
			flash[:success] = "Your password has been saved."
			sign_in(@user)
			@title = @user.name
			render 'show'
		else
			@user.password_reset_token = params[:user][:password_reset_token]
			@title = "Enter new password"
			render 'users/get_reset_password'
		end
	end

###########################################################	
	private
	
		def user_params
			params.require(:user).permit(:name, :email, :password,
				:password_confirmation )
		end
	
		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_path) unless current_user?(@user)
		end
		
		def signed_in_user
			unless signed_in?
				store_location
				redirect_to signin_url, notice: "Please sign in."
			end
		end

		def change_password
			updated_user = User.find_by(email: @user.email)
			if updated_user && updated_user.authenticate(user_params[:password])
				if @user.change_password(user_params, params[:new_password],
						params[:new_password_confirm])
					flash[:success] = "Password changed"
					redirect_to @user
					return
				end
			else
				@user.errors.add(:password, "is incorrect.")
			end
			edit_password
			render 'edit_password'
		end
end





