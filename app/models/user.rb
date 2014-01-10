class User < ActiveRecord::Base
	
	# fields: id, name, email, qwyzs, 
	#					last_login_at, create_at, updated_at, email_confirmed_at,
	
	# attr_accessor :name, :email, :password, 
			# :password_confirmation, :status
	MIN_PASS_LENGTH = 8

	has_many :qwyzs
	before_save do 
		self.email = email.downcase
		self.name	= name.downcase
	end
	
	before_create :create_tokens
	validates :name,		presence: 	true,
											length: 		{ maximum: 50 },
											uniqueness: { case_sensitive: false}
	EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, 	presence: 	true,
											format: 		{ with: EMAIL_REGEX },
											uniqueness: { case_sensitive: false }
	has_secure_password
	validates :password, length:	 { within: MIN_PASS_LENGTH..40 }

	STATUS = {
		pending_email: 	1,
		activated: 			50,
		deactivated: 		200,
	}

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	def deactivated?
		self.status == STATUS[:deactivated]
	end
	
	def activated?
		self.status == STATUS[:activated]
	end
	
	def pending_email?
		self.status == STATUS[:pending_email]
	end

	def change_password(user_params, new_password, 
				new_password_confirm)
		updated_params = user_params
		updated_params[:password] = new_password
		updated_params[:password_confirmation] = 
				new_password_confirm
		if self.update_attributes(updated_params)
			return true
		else
			self.errors.delete(:password)
			self.errors.delete(:password_confirmation)
			if new_password.length < User::MIN_PASS_LENGTH
				self.errors.add(:new_password, 
						"must be at least #{User::MIN_PASS_LENGTH} characters")
			end
			if new_password.to_s != new_password_confirm
				self.errors.add(:new_password, "must match confirmation")
			end
			return false
		end
	end

	private

		def create_tokens
			self.remember_token = User.encrypt(User.new_remember_token)
			self.activation_token = SecureRandom.uuid
		end

end

