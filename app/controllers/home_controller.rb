
class HomeController < ApplicationController
	
	def index
		# TODO for now just grab first ten.
		@qwyz_list = Qwyz.take(20)
		
		# TODO get all the authors also.
		
		
		
		@title = "Home"
		render 'pages/home'
	end
	
end