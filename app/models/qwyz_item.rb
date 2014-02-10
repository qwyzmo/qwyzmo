class QwyzItem < ActiveRecord::Base
	belongs_to :qwyz
	mount_uploader :image, ImageUploader
	
	# TODO implement validations and ties to image uploader.
	
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