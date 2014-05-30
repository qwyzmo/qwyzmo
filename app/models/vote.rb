
class Vote < ActiveRecord::Base
	belongs_to :qwyz
	
	validates :qwyz_id, 					presence: true
	validates :left_item_id, 		presence: true
	validates :right_item_id, 	presence: true
	validates :chosen_item_id, 	presence: true
	validates_uniqueness_of :chosen_item_id, scope: [:left_item_id, 
						:right_item_id, :voter_user_id, :voter_ip_address]
	
	validate :chosen_is_valid, :left_right_different, :items_belong_to_qwyz

	# validates that the chosen item is equal to either the left or right item id.
	def chosen_is_valid
		if chosen_item_id != left_item_id && chosen_item_id != right_item_id
			errors.add(:chosen_item_id, "must equal either right or left item id")
		end
	end
	
	# validates that the left and right item ids in this vote are not equal.
	def left_right_different
		if left_item_id == right_item_id
			errors.add(:right_item_id, "can't be equal to left item id")
		end
	end

	# validates that all items in this vote belong to this votes qwyz.
	def items_belong_to_qwyz
		begin
			qwyz = Qwyz.find(qwyz_id)
		rescue
			errors.add(:qwyz_id, "must be a valid qwyz")
			return
		end
		if qwyz.item(left_item_id).nil?
			errors.add(:left_item_id, "must exist in qwyz")
		end
		if qwyz.item(right_item_id).nil?
			errors.add(:right_item_id, "must exist in qwyz")
		end
		if qwyz.item(chosen_item_id).nil?
			errors.add(:chosen_item_id, "must exist in qwyz")
		end
	end

	# returns list of all votes belonging to the qwyz and user ( or ip if no user id )
	# 	includes votes for inactive and active items.
	def self.votelist( qwyz_id, user_id, ip)
		if user_id.nil?
			return Vote.where(qwyz_id: qwyz_id, voter_ip_address: ip).load
		else
			return Vote.where(qwyz_id: qwyz_id, voter_user_id: user_id).load
		end
	end
	
	# create and save a vote, return false if unsuccessful
	def self.cast(qwyz_id, left_id, right_id, chosen_id, user_id, ip)
		vote 									= Vote.new
		vote.qwyz_id					= qwyz_id
		vote.left_item_id 		= left_id
		vote.right_item_id 		= right_id
		vote.chosen_item_id 	= chosen_id
		vote.voter_user_id 		= user_id
		vote.voter_ip_address = ip
		vote.save
	end
end












