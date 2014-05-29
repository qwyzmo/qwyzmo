
class HomeController < ApplicationController
	
	def index
		# TODO for now just grab first 50 in descending order by update date.
		@qwyz_list = Qwyz.limit(50).order(updated_at: :desc)
		@qwyz_to_author_map = Qwyz.id2author(@qwyz_list)
		@title = "Home"
		@show_creator = params.key?("showcreator")
		render 'pages/home'
	end
	
end