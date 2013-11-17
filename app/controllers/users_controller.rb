class UsersController < ApplicationController
	before_filter :authenticate,		only: [:index, :edit, :update, :change_status]
	before_filter :correct_user,		only: [:edit, :update]
	before_filter :admin_user,			only: :change_status

	def index
		@title = "All users"
		@users = User.paginate(:page => params[:page])
	end

	def show
		@user = User.find(params[:id])
		@microposts = @user.microposts.paginate(:page => params[:page])
		@title = @user.name
	end
	
	def change_password
		puts ")_)_)_)_)>> change password called. params=#{params.inspect}"
		# if two new passwords dont match, redirect to change passwords page with error.
		if params[:new_password] != params[:new_password_confirm]
			flash[:error] = "New password and confirmation must match"
			redirect change_password_path
			return
		end
	end

	def new
		if signed_in?
			flash[:info] = "You are already logged in, so you cannot create a new account."
			redirect_to root_path
		else
			@user = User.new
			@title = "Sign up"
		end
	end

	def create
		if signed_in?
			flash[:info] = "You are already loggin in, so you cannot create a new account."
			redirect_to root_path
		else
			@user = User.new(params[:user])
			if @user.save_new
				sign_in @user
				flash[:success] = "Welcome to Qwyzmo!"
				redirect_to @user
			else
				@title = "Sign up"
				@user.password = ""
				@user.password_confirmation = ""
				render 'new'
			end
		end
	end

	def edit
		@title= "Edit Account Info"
	end

	def update
		@user = User.find(params[:id])
		if @user.update_attributes(params[:user])
			flash[:success] = "Profile updated."
			redirect_to @user
		else
			@title = "Edit user"
			render 'edit'
		end
	end

	def change_status
		@user = User.find(params[:user][:id])
		@user.update_status(params[:user][:status].to_i)
		redirect_to users_path
	end

	# check if status should be updated, if so update and redirect
	# and return true else return false.
	# def update_status user, new_status
		# # first check if status is being changed at all
		# if new_status.nil? || new_status.to_i == user.status
			# return false
		# end
		# if !current_user.admin?
			# flash[:error] = "Only admins may change a user's status"
			# redirect_to root_path
		# else 
		# end
		# return true
	# end
	
	private
	
		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_path) unless current_user?(@user)
		end
		
		def admin_user
			redirect_to(root_path) unless current_user.admin?
		end
end





