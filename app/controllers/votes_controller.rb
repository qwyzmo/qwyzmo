
class VotesController < ApplicationController
	
	
	def new
		@qwyz = Qwyz.find(params[:qwyz_id])
		current_user_id = current_user.nil? ? nil : current_user.id
		@left_item, @right_item = 
					@qwyz.item_choice(current_user_id, request.remote_ip)
		if	@left_item.nil? || @right_item.nil?
			@title = "Qwyz Summary"
			index
			return
		else
			@title = "Vote"
			render :new
		end
	end

	def create
		# TODO: record the vote, call new
	end
	
	def index
		# TODO: get all votes, sum them per item. 
		#   perhaps create a vote summary model object.
		
		@title = "Qwyz Vote Summary"
		render :index
	end
end

# TODO: implement
