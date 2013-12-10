class User < ActiveRecord::Base
	
	# fields: id, name, email, qwyzs, 
	#  				last_login_at, create_at, updated_at, email_confirmed_at,
	
	# attr_accessor :name, :email, :password, 
			# :password_confirmation, :status

	has_many :qwyzs

	EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates :name,		presence: 	true,
											length: 		{ maximum: 50 },
											uniqueness: { case_sensitive: false}
	validates :email, 	presence: 	true,
											format: 		{ with: EMAIL_REGEX },
											uniqueness: { case_sensitive: false }
	# validates :password, length:					{ within: 8..40 }

  # has_secure_password
  
  before_save do 
  	self.email = email.downcase
  	self.name  = name.downcase
  end

	STATUS = {
		pending_email: 	1,
		activated: 			50,
		deactivated: 		200,
	}

	# Return true if the user's password matches the submitted password.
	def has_password?(submitted_password)
		# compare encrypted_password with the encrypted version of submitted_password.
		encrypted_password == encrypt(submitted_password)
	end

	def self.authenticate email, submitted_password
		user = find_by_email email
		return nil if user.nil?
		return user if user.has_password? submitted_password
	end

	def self.authenticate_with_salt id, cookie_salt
		user = find_by_id id
		(user && user.salt == cookie_salt) ? user : nil
	end

	def feed
		Micropost.where("user_id = ?", id)
	end

	def deactivated?
		self.status == STATUS[:deactivated]
	end
	
	def encrypt_save
		encrypt_password
		self.save
	end
	
	def encrypt_save!
		encrypt_password
		self.save!
	end
	
	# def self.create attr
		# user = User.new attr
		# user.encrypt_save
		# user
	# end
# 	
	# def self.create! attr
		# user = User.new attr
		# user.encrypt_save!
		# user
	# end

	private

		def encrypt_password
			self.salt = make_salt if new_record?
			self.encrypted_password = encrypt(@password)
		end
	
		def encrypt(string)
			secure_hash("#{salt}--#{string}")
		end
	
		def make_salt
			secure_hash("#{Time.now.utc}--#{password}")
		end
	
		def secure_hash(string)
			Digest::SHA2.hexdigest(string)
		end
end

