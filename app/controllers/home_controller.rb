
class HomeController < ApplicationController
	
	def index
		# TODO for now just grab first ten.
		@qwyz_list = Qwyz.take(10)
		@title = "Home"
		render 'pages/home'
	end
	
end