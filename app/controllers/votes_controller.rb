
class VotesController < ApplicationController
	
	MIN_VOTES_TIL_RESULTS = 6
	
	def new
		@qwyz = Qwyz.find(params[:qwyz_id])
		current_user_id = current_user.nil? ? nil : current_user.id
		@left_item, @right_item = @qwyz.item_choice(current_user_id, request.remote_ip)
		if	@left_item.nil? || @right_item.nil?
			@qwyz_result = QwyzResult.new(@qwyz)
			index
		else
			@qwyz_owner = User.find(@qwyz.user_id)
			set_results_button_info(@qwyz, current_user_id, request.remote_ip)
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
	
	private ###########################################
	
	# sets the boolean for showing the results button and also the number of 
	# votes left before results button shows.
	def set_results_button_info(qwyz, current_user_id, current_user_ip)
		# get the number of votes cast by this user.
		votes_cast = Vote.votelist(qwyz.id, current_user_id, current_user_ip).count
		# pick min of: total number of votes, min_votes_til_results
		total_votes_needed = [qwyz.total_possible_vote_count(), MIN_VOTES_TIL_RESULTS].min
		@votes_til_results = total_votes_needed - votes_cast
		@show_results = @votes_til_results <= 0
	end
end






