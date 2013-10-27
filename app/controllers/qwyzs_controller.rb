class QwyzsController < ApplicationController
	before_filter :authenticate
  before_filter :correct_user,   only: :destroy

	def create
		@qwyz = current_user.qwyzs.build(params[:qwyz])
		if @qwyz.save
			#flash[:success] = "Qwyz created!"
			redirect_to qwyzs_path
		else
			#flash[:error] = "Missing Fields"
			#flash.discard
			render action: "add"
		end
	end

	def add
		@title = "Create a New Qwyz"
		if signed_in?
			@qwyz = Qwyz.new
		end
	end

	def index
		@title = "My Qwyzs"
		@qwyzs = current_user.qwyzs.paginate(:page => params[:page])
	end

	def destroy
		@qwyz.destroy
		# index
		redirect_to qwyzs_url
	end

	private

		def correct_user
			begin
				@qwyz = current_user.qwyzs.find(params[:id])
			rescue
				redirect_to qwyzs_url if @qwyz.nil?
			end
		end
end





