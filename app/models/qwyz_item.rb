class QwyzItem < ActiveRecord::Base
	belongs_to :qwyz
	mount_uploader :image, ImageUploader
	
	# TODO implement validations and ties to image uploader.
end