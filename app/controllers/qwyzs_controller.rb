
class QwyzsController < ApplicationController
	before_filter :authenticate
	before_filter :correct_user,
								:only => [:destroy, :edit, :update]

	def new
		@title = "Create a New Qwyz"
		@qwyz = Qwyz.new
	end
	
	def create
		@qwyz = current_user.qwyzs.build(qwyz_params)
		if @qwyz.save
			flash[:success] = "Qwyz created."
			index
			render :index
		else
			@title = "Create a New Qwyz"
			render :new
		end
	end

	def edit
		@title = "Edit Qwyz"
		@qwyz = Qwyz.find(params[:id])
		if @qwyz.nil?
			index
			render :index
		end
	end
	
	def update
		@qwyz = Qwyz.find(params[:id])
		if @qwyz.update_attributes(qwyz_params)
			flash[:success] = "Qwyz updated."
			index
			render :index
		else
			@title = "Edit Qwyz"
			render :edit
		end
	end

	def show
		# TODO implement show
	end
	
	def index
		@title = "My Qwyzs"
		@qwyzs = current_user.qwyzs
	end

	def destroy
		@qwyz.destroy
		index
		render :index
	end

	private
	
		def qwyz_params
			params.require(:qwyz).permit(:user_id, :name, 
					:question, :description )
		end

		def correct_user
			begin
				@qwyz = current_user.qwyzs.find(params[:id])
			rescue
				redirect_to qwyzs_url if @qwyz.nil?
			end
		end
end





