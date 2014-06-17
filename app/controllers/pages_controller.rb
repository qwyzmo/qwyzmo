class PagesController < ApplicationController
	def db_stats
		@user_count = DbStats.query_num("users")
		@vote_count = DbStats.query_num("votes")
		@qwyz_count = DbStats.query_num("qwyzs")
	end
end
