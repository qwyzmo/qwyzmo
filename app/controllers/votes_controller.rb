
class VotesController < ApplicationController
	
	
	def new
		@qwyz = Qwyz.find(params[:qwyz_id])
		@left_item, @right_item = @qwyz.next_unvoted_item_pair(
						current_user, request.remote_ip)
		if	@right_item.nil?
			render "qwyzs/qwyz_summary"
		else
			render :new
		end
	end

	def create
		# record the vote, call new and render new.
	end
end

# TODO: implement
