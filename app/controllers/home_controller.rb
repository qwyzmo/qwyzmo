
class HomeController < ApplicationController
	
	def index
		# TODO for now just grab first ten.
		@qwyz_list = Qwyz.find(:all, limit: 10)
		render 'pages/home'
	end
	
end