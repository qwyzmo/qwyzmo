
class Vote < ActiveRecord::Base
	belongs_to :qwyz
	
	validates :qwyz_id, 					presence: true
	validates_presence_of :qwyz
	validates :left_item_id, 		presence: true
	validates :right_item_id, 	presence: true
	validates :chosen_item_id, 	presence: true


end

# TODO: implement