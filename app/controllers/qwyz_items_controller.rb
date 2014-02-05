
class QwyzItemsController < ApplicationController
	before_filter :authenticate
	before_filter :correct_user_and_qwyz,
								:only => [:destroy, :edit, :update]
	# TODO: create correct authentication before filters for user and qwyz
	
	
	def new
		
	end
	
	def create
		
	end
	
	def show
		
	end
	
	def index
		
	end
	
	def edit
		
	end
	
	def update
		
	end
	
	def destroy
		
	end
	
	private
	
		def qwyz_item_params
			
		end
	
		def correct_user_and_qwyz
			
		end
end


# TODO: implement