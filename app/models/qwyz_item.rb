class QwyzItem < ActiveRecord::Base
	
	belongs_to :qwyz
	
	# TODO implement validations and ties to image uploader.
end