class UsersController < ApplicationController

	before_action :signed_in_user, only: [:edit, :update]
	before_action :correct_user,	 only: [:edit, :update]

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
			# TODO: send email here.
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
			else
				edit
				render 'edit'
			end
		else
			@user.errors.add(:password, "is incorrect.")
			edit
			render 'edit'
		end
	end
	
	def edit_password
		@title = "Change Password"
		@user ||= User.find(params[:id])
	end

	def change_password
		updated_user = User.find_by(email: @user.email)
		if updated_user && updated_user.authenticate(user_params[:password])
			updated_params = user_params
			updated_params[:password] = params[:new_password]
			updated_params[:password_confirmation] = 
						params[:new_password_confirm]
			if @user.update_attributes(updated_params)
				flash[:success] = "Password Changed"
				redirect_to @user
			else
				@user.errors.delete(:password)
				@user.errors.delete(:password_confirmation)
				if params[:new_password].length < User::MIN_PASS_LENGTH
					@user.errors.add(:new_password, 
							"must be at least #{User::MIN_PASS_LENGTH} characters")
				end
				if params[:new_password].to_s != params[:new_password_confirm]
					@user.errors.add(:new_password, "must match confirmation")
				end
				edit_password
				render 'edit_password'
			end
		else
			@user.errors.add(:password, "is incorrect.")
			edit_password
			render 'edit_password'
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
end





