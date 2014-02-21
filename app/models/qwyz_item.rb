class QwyzItem < ActiveRecord::Base
	belongs_to :qwyz
	mount_uploader :image, ImageUploader
	
	validates :qwyz_id, presence: true
	validates_presence_of :qwyz
	validates :description, presence: true
	validates :image, presence: true

	STATUS = {
		active: 						1,
		inactive: 					2,
		pending_approval:		3, # this is for qwyz_items that others submit
		rejected:						4, # also for submitted items in a public qwyz.
	}
	
	TYPE = {
		image: 			100,
		video:			200,
	}
	
	def active?
		return status == STATUS[:active]
	end
	
	def inactive?
		return status == STATUS[:inactive]
	end
	
end