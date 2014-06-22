
class VotesController < ApplicationController
	
	MIN_VOTES_TIL_RESULTS = 6
	
	def new
		@qwyz = Qwyz.find(params[:qwyz_id])
		current_user_id = current_user.nil? ? nil : current_user.id
		@left_item, @right_item = @qwyz.item_choice(current_user_id, request.remote_ip)
		if	@left_item.nil? || @right_item.nil?
			@qwyz_result = QwyzResult.new(@qwyz, current_user_id, request.remote_ip)
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
				chosen_id(params), current_user_id, request.remote_ip)
		new
	end
	
	def index
		current_user_id = current_user.nil? ? nil : current_user.id
		@qwyz = Qwyz.find(params[:qwyz_id])
		@remaining_vote_count = @qwyz.remaining_vote_count(current_user_id, request.remote_ip)
		@total_possible_votes = @qwyz.total_possible_vote_count()
		@votes_cast = @total_possible_votes - @remaining_vote_count
		@author = User.find(@qwyz.user_id)
		@qwyz_result = QwyzResult.new(@qwyz, current_user_id, request.remote_ip)
		@title = "Qwyz Vote Summary"
		render :index
	end
	
	private ###########################################
	
	## this is rather ugly.  choose left or right id based on presence of "left.x"
	## 	I do this to get around differences in firefox vs chrome when using an image
	## 	as the button in a form.
	def chosen_id(params)
		if params["left.x"]
			params[:left_item_id]
		else
			params[:right_item_id]
		end
	end
	
	# sets the boolean for showing the results button and also the number of 
	# votes left before results button shows.
	def set_results_button_info(qwyz, current_user_id, current_user_ip)
		# get the number of votes cast by this user.
		@remaining_vote_count = @qwyz.remaining_vote_count(current_user_id, request.remote_ip)
		@total_possible_votes = @qwyz.total_possible_vote_count()
		@votes_cast = @total_possible_votes - @remaining_vote_count
\
		# pick min of: total number of votes, min_votes_til_results
		total_votes_needed = [@total_possible_votes, MIN_VOTES_TIL_RESULTS].min
		@votes_til_results = total_votes_needed - @votes_cast
		@show_results = @votes_til_results <= 0
	end
end






