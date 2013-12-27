class UsersController < ApplicationController
	# before_filter :authenticate,		only: [:index, :edit, :update, :change_status]
	# before_filter :admin_user,			only: :change_status
	
	before_action :signed_in_user, only: [:edit, :update]
	before_action :correct_user,   only: [:edit, :update]
	
	
	def index
		@title = "All users"
		@users = User.all
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
			sign_in @user
			flash[:success] = "Welcome to the Sample App!"
			redirect_to @user
		else
			render 'new'
		end
	end

	# def create
		# puts "+++++++>> params = #{params.inspect}"
		# if signed_in?
			# flash[:info] = "You are already loggin in, so you cannot create a new account."
			# redirect_to root_path
		# else
			# # require 'pry'; binding.pry
			# @user = User.new(user_params)
			# puts "-=-=-=-=->>> user = #{@user.inspect}"
			# # puts "~~~~~~> activerecord version = " + 
					# # "#{Gem.loaded_specs["activerecord"].version}"
			# if @user.encrypt_save
				# sign_in @user
				# flash[:success] = "Welcome to Qwyzmo!"
# #				UserMailer.confirm_email(@user).deliver
				# redirect_to @user
			# else
				# @title = "Sign up"
				# @user.password = ""
				# @user.password_confirmation = ""
				# render 'new'
			# end
		# end
	# end

	def edit
		@title = "Edit Account Info"
	end

	def update
		updated_user = User.find_by(email: @user.email)
		if updated_user && updated_user.authenticate(user_params[:password])
			updated_params = user_params
			updated_params[:password_confirmation] = updated_params[:password]
			if @user.update_attributes(updated_params)
				flash[:success] = "Profile updated"
				redirect_to @user
			else
				@title = "Edit Account Info"
				render 'edit'
			end
		else
			flash[:error] = "Incorrect password."
			edit
			render'edit'
		end
	end
	
	def edit_password
		@title = "Change Password"
		
	end
	
	def change_password
		if params[:new_password] != params[:new_password_confirm]
			flash[:error] = "New password and confirmation must match"
			redirect change_password_path
			return
		else
			# validate that the password is correct.
			original = User.find(params[:user][:id])
			@user = User.authenticate(original.email, 
					params[:user][:password])
			if @user.nil? 
				flash[:error] = "Wrong password"
				redirect change_password_path
			else
				@user.password = params[:new_password]
				@user.encrypt_save
				@user.password = nil
				render 'edit'
			end
			
		end
	end

	def change_status
		puts "319-------->> change status"
		@user = User.find(params[:user][:id])
		@user.update_attribute('status', params[:user][:status].to_i )
		redirect_to users_path
	end
	
###########################################################	
	private
	
		def user_params
			params.require(:user).permit(:name, :email, :password,
				:password_confirmation)
		end
	
		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_path) unless current_user?(@user)
		end

		def admin_user
			redirect_to(root_path) unless current_user.admin?
		end
		
		def signed_in_user
			unless signed_in?
				flash[:notice] = "Please sign in."
				redirect_to signin_url
			end
		end
end





