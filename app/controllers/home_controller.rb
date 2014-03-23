
class HomeController < ApplicationController
	
	def index
		# TODO for now just grab first twenty
		@qwyz_list = Qwyz.take(20)
		@qwyz_to_author_map = User.qwyz_id_to_author(@qwyz_list)
		@title = "Home"
		render 'pages/home'
	end
	
end