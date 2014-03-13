
class VotesController < ApplicationController
	
	
	def new
		@qwyz = Qwyz.find(params[:qwyz_id])
		current_user_id = current_user.nil? ? nil : current_user.id
		@left_item, @right_item = 
					@qwyz.item_choice(current_user_id, request.remote_ip)
		if	@left_item.nil? || @right_item.nil?
			@title = "Qwyz Summary"
			@qwyz_result = QwyzResult.new(@qwyz)
			index
		else
			@vote = Vote.new
			@title = "Vote"
			render :new
		end
	end

	def create
		current_user_id = current_user.nil? ? nil : current_user.id
		Vote.cast(params[:qwyz_id], params[:left_item_id], params[:right_item_id], 
				params[:commit], current_user_id, request.remote_ip)
		new
	end
	
	def index
		@qwyz = Qwyz.find(params[:qwyz_id])
		@author = User.find(@qwyz.user_id)
		@qwyz_result = QwyzResult.new(@qwyz)
		@title = "Qwyz Vote Summary"
		render :index
	end
end

