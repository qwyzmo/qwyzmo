class UsersController < ApplicationController

	before_action :signed_in_user, only: [:edit, :update]
	before_action :correct_user,	 only: [:edit, :update]

	ACTIVATION_TOKEN_NAME = "atok"

	# TODO: remove this soon, temporary for testing.
	def testemail
		user_params = {email: 'qwyzmo@yahoo.com', name: 'test7353'}
		user = User.new(user_params)
		UserMailer.confirm_email(user).deliver
	end

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
	
	def edit_password
		@title = "Change Password"
		@user ||= User.find(params[:id])
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

	def forgot_password
		@title = "Reset password"
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
end





