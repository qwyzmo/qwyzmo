class PagesController < ApplicationController
	def db_stats
		@user_count 		= DbStats.query_num("users")
		@vote_count 		= DbStats.query_num("votes")
		@qwyz_count 		= DbStats.query_num("qwyzs")
		@votes_per_ip 	= DbStats.votes_per_ip()
		@recent_votes_per_ip = DbStats.recent_votes_per_ip()
	end
end
