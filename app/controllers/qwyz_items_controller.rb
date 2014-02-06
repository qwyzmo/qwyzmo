
class QwyzItemsController < ApplicationController
	before_filter :authenticate
	before_filter :correct_user_and_qwyz,
								:only => [:destroy, :edit, :update]
	# TODO: create correct authentication before filters for user and qwyz
	
	
	def new
		@title = "Add a new Qwyz item"
		@qwyz = Qwyz.find(params[:qwyz_id])
		@qwyz_item = QwyzItem.new
	end
	
	def create
		@qwyz = Qwyz.find(params[:qwyz_id])
		@qwyz_item = @qwyz.qwyz_items.build(qwyz_item_params)
		if @qwyz_item.save
			flash[:success] = "Qwyz item created."
			redirect_to qwyz_path(@qwyz)
		else
			@title = "Add a new Qwyz item"
			render :new
		end
	end
	
	def show
		
	end
	
	def index
		
	end
	
	def edit
		
	end
	
	def update
		
	end
	
	def destroy
		
	end
	
	private
	
		def qwyz_item_params
			params.require(:qwyz_item).permit(:qwyz_id, :description)
		end
	
		def correct_user_and_qwyz
			
		end
end


# TODO: implement