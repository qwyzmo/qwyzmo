class QwyzsController < ApplicationController
	before_filter :authenticate

	def create
		@qwyz = current_user.qwyzs.build(params[:qwyz])
		if @qwyz.save
			flash[:success] = "Qwyz created!"
			redirect_to root_path
		else
			render 'pages/home'
		end
	end

	def index
		@title = "My Qwyzs"
		@qwyzs = current_user.qwyzs.paginate(:page => params[:page])
	end

end