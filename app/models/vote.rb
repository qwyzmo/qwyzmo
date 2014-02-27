
class Vote < ActiveRecord::Base
	belongs_to :qwyz
	
	validates :qwyz_id, 					presence: true
	validates_presence_of :qwyz
	validates :left_item_id, 		presence: true
	validates :right_item_id, 	presence: true
	validates :chosen_item_id, 	presence: true


	def self.votelist( qwyz_id, user_id, ip)
		if user_id.nil?
			return Vote.find_by(qwyz_id: qwyz_id, voter_ip_address: ip)
		else
			return Vote.find_by(qwyz_id: qwyz_id, voter_user_id: user_id)
		end
	end
end

