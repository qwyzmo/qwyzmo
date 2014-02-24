
class Vote < ActiveRecord::Base
	belongs_to :qwyz
	
	validates :qwyz_id, 					presence: true
	validates_presence_of :qwyz
	validates :left_item_id, 		presence: true
	validates :right_item_id, 	presence: true
	validates :chosen_item_id, 	presence: true


	def self.get_votes_by_voter( qwyz_id, user, ip)
		if user.nil?
			return Vote.find_by(qwyz_id: @qwyz.id, voter_ip_address: ip)
		else
			return Vote.find_by(qwyz_id: @qwyz.id, voter_user_id: @user.id)
		end
	end
end

# TODO: implement