class User < ActiveRecord::Base
	attr_accessor :password
	attr_accessible :name, :email, :password, 
			:password_confirmation, :status

	# TODO: remove microposts
	has_many :microposts, :dependent => :destroy
	has_many :qwyzs

	EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates :name,		presence: 	true,
											length: 		{ within: 1..50 },
											uniqueness: { case_sensitive: false}
	validates :email, 	presence: 	true,
											format: 		{ with: EMAIL_REGEX },
											uniqueness: { case_sensitive: false }

	# Automatically create the virtual attribute password_confirmation.
	validates :password, presence: 			true,
												confirmation:		true,
												length:					{ within: 6..40 }

	STATUS = {
		deactivated: 100,
		activated: 101,
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

