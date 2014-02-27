
class VotesController < ApplicationController
	
	
	def new
		@qwyz = Qwyz.find(params[:qwyz_id])
		current_user_id = current_user.nil? ? nil : current_user.id
		@left_item, @right_item = 
					@qwyz.item_choice(current_user_id, request.remote_ip)
		if	@left_item.nil? || @right_item.nil?
			render "qwyzs/qwyz_summary"
		else
			render :new
		end
	end

	def create
		# record the vote, call new
	end
end

# TODO: implement
