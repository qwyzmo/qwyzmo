class User < ActiveRecord::Base
	attr_accessor :password
	attr_accessible :name, :email, :password, :password_confirmation

	STATUS = {
		activated: 101,
		deactivated: 100,
	}


	# todo: remove microposts
	has_many :microposts, :dependent => :destroy
	has_many :qwyzs

	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates :name,		presence: 	true,
											length: 		{ maximum: 50 },
											uniqueness: { case_sensitive: false}
	validates :email, 	presence: 	true,
											format: 		{ with: email_regex },
											uniqueness: { case_sensitive: false }

	# Automatically create the virtual attribute password_confirmation.
	validates :password, presence: 			true,
												confirmation:		true,
												length:					{ within: 6..40 }

	before_save :encrypt_password
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
	
	# return true if the status was changed
	def update_status new_status
		puts "----> update_status, new status = #{new_status}, self status = #{self.status}"
		if new_status != self.status
			@skip_encrypt = true
			self.status = new_status
			result = self.save false
			puts "===> result=#{result}, user = #{self.inspect}"
			return true
		else
			return false
		end
	end
	
	# def get_qwyzs
		# Qwyz.where("user_id = ?", id)
	# end

	private

		def encrypt_password
			if !@skip_encrypt
				self.salt = make_salt if new_record?
				self.encrypted_password = encrypt(@password)
			end
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

# == Schema Information
#
# Table name: users
#
#	id				 :integer				 not null, primary key
#	name			 :string(255)
#	email			:string(255)
#	created_at :datetime
#	updated_at :datetime
#

