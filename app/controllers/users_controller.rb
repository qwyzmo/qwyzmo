class UsersController < ApplicationController
	before_filter :authenticate,							only: [:index, :edit, :update]
	before_filter :correct_user,							only: [:edit]
	before_filter :admin_or_correct_user,	only: :update

	def index
		@title = "All users"
		@users = User.paginate(:page => params[:page])
	end

	def show
		@user = User.find(params[:id])
		@microposts = @user.microposts.paginate(:page => params[:page])
		@title = @user.name
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
			if @user.save
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
		@title= "Edit user"
	end

	def update
		@user = User.find(params[:id])
		if update_status( @user, params[:user][:status] )
			return
		elsif @user.update_attributes(params[:user])
			flash[:success] = "Profile updated."
			redirect_to @user
		else
			@title = "Edit user"
			render 'edit'
		end
	end
	
	# check if status should be updated, if so update and redirect
	# and return true else return false.
	def update_status user, new_status
		# first check if status is being changed at all
		if new_status.nil? || new_status.to_i == user.status
			return false
		end
		if !current_user.admin?
			flash[:error] = "Only admins may change a user's status"
			redirect_to root_path
		else 
			user.update_status(new_status.to_i)
			redirect_to users_path
		end
		return true
	end
	
	private
	
		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_path) unless current_user?(@user)
		end
		
		def admin_user
			redirect_to(root_path) unless current_user.admin?
		end
		
		def admin_or_correct_user
			@user = User.find(params[:id])
			redirect_to(root_path) unless (current_user?(@user) || current_user.admin?)
		end
end





