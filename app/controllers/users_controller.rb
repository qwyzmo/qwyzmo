class UsersController < ApplicationController
	before_filter :authenticate,		only: [:index, :edit, :update, :change_status]
	before_filter :correct_user,		only: [:edit, :update]
	before_filter :admin_user,			only: :change_status

	def index
		@title = "All users"
		@users = User.all
	end

	def show
		@user = User.find(params[:id])
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
			if @user.encrypt_save
				sign_in @user
				flash[:success] = "Welcome to Qwyzmo!"
				UserMailer.confirm_email(@user).deliver
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
		puts "9933-----------> update"
		original = User.find(params[:id])
		@user = User.authenticate( original.email, 
				params[:user][:password])
		if @user.nil?
			original.attributes= params[:user]
			@user = original
			@user.password = nil
			@user.errors[:password] = "is incorrect."
			edit
			render'edit'
		else
			@user.attributes= params[:user]
			if @user.save
				flash[:success] = "Account updated."
				render 'show'
			else
				@user.password = nil
				edit
				render 'edit'
			end
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
	
	private
	
		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_path) unless current_user?(@user)
		end
		
		def admin_user
			redirect_to(root_path) unless current_user.admin?
		end
end





