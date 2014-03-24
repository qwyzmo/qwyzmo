class User < ActiveRecord::Base
	
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

###################### password methods

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
	
	def self.create_password_reset_token(email)
		user = User.find_by(email: email.downcase)
		if user
			user.update_attribute(
					:password_reset_token, SecureRandom.uuid)
			user.update_attribute(
					:password_reset_token_date, DateTime.now)
		end
		return user
	end

	def self.find_by_password_reset_token_if_valid(password_token)
		user = User.find_by(password_reset_token: password_token)
		if user && user.password_reset_token_recent?
			return user
		else
			return nil
		end
	end
	
	def password_reset_token_recent?
		password_reset_token_date > DateTime.now - 0.05
	end
	
	def self.reset_password(	name, password, password_confirmation, 
												password_reset_token)
		db_user = User.find_by(name: name)
		if !db_user
			user = User.new
			user.errors.add(:name, 'is not found')
			return user
		end
		if !db_user.password_reset_token_valid?(password_reset_token)
			return nil
		end
		db_user.password 									= password
		db_user.password_confirmation 		= password_confirmation
		db_user.password_reset_token 			= nil
		db_user.password_reset_token_date	= nil
		db_user.save
		return db_user
	end
	
	def password_reset_token_valid?(token)
		return password_reset_token == token &&
						!password_reset_token.empty? &&
						password_reset_token_recent?
	end

	private

		def create_tokens
			self.remember_token = User.encrypt(User.new_remember_token)
			self.activation_token = SecureRandom.uuid
		end

end







