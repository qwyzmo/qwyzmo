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
		puts "-=-=-=-=-=->>> users controller update called, params user = #{params[:user].inspect}"
		@user = User.find(params[:id])
		puts "=======> @user = #{@user.inspect}"
		if params[:user][:status] != @user.status
			@user.status = params[:user][:status].to_i
			result = @user.save(false)
			puts "|||||||||||||||||||||||>> saving status, result = #{result}, @user = #{@user.inspect}"
			redirect_to users_path
		elsif @user.update_attributes(params[:user])
			flash[:success] = "Profile updated."
			redirect_to @user
		else
			@title = "Edit user"
			render 'edit'
		end
	end
	
	# def destroy 
		# user = User.find(params[:id])
		# if current_user? user
			# flash[:info] = "You cannot destroy the current user."
			# redirect_to users_path
		# else
			# user.destroy
			# flash[:success] = "User destroyed."
			# redirect_to users_path
		# end
	# end
	
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





