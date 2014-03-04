
class Vote < ActiveRecord::Base
	belongs_to :qwyz
	
	validates :qwyz_id, 					presence: true
	validates_presence_of :qwyz
	validates :left_item_id, 		presence: true
	validates_presence_of :left_item_id
	validates :right_item_id, 	presence: true
	validates_presence_of :right_item_id
	validates :chosen_item_id, 	presence: true
	validates_presence_of :chosen_item_id
	
	validate :chosen_is_valid, :left_right_different, :items_belong_to_qwyz

	def chosen_is_valid
		if chosen_item_id != left_item_id && chosen_item_id != right_item_id
			errors.add(:chosen_item_id, "must equal either right or left item id")
		end
	end
	
	def left_right_different
		if left_item_id == right_item_id
			errors.add(:right_item_id, "can't be equal to left item id")
		end
	end

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

	def self.votelist( qwyz_id, user_id, ip)
		if user_id.nil?
			return Vote.where(qwyz_id: qwyz_id, voter_ip_address: ip).load
		else
			return Vote.where(qwyz_id: qwyz_id, voter_user_id: user_id).load
		end
	end
end

