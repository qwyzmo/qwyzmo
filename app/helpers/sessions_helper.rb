module SessionsHelper

	def sign_in(user)
		remember_token = User.new_remember_token
		cookies.permanent[:remember_token] = remember_token
		user.update_attribute(:remember_token, User.encrypt(remember_token))
		self.current_user = user
	end

	def current_user= user
		@current_user = user
	end

	def current_user
		remember_token = User.encrypt(cookies[:remember_token])
		@current_user ||= User.find_by(remember_token: remember_token)
	end

	def current_user?(user)
		user == current_user
	end

	def signed_in?
		!current_user.nil?
	end

	def sign_out
		cookies.delete(:remember_token)
		self.current_user = nil
	end

	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		clear_return_to
	end
	
	def authenticate
		deny_access unless signed_in?
	end
	
	def deny_access
		store_location
		redirect_to signin_path, :notice => "Please sign in to access this page."
	end
	
	private

		def user_from_remember_token
			User.authenticate_with_salt(*remember_token)
		end
	
		def remember_token
			cookies.signed[:remember_token] || [nil,nil]
		end
		
		def store_location
			session[:return_to] = request.fullpath
		end
		
		def clear_return_to
			session[:return_to] = nil
		end
end



