
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
			# redirect_to qwyz_path(@qwyz)
			render 'qwyzs/show'
		else
			@title = "Add a new Qwyz item"
			render :new
		end
	end
	
	def show
		@title = "View Qwyz Item"
	end
	
	def index
		# TODO: implement
	end
	
	def edit
		@title = "Edit Qwyz Item"
		@qwyz = Qwyz.find(params[:qwyz_id])
		@qwyz_item = QwyzItem.find(params[:id])
	end
	
	def update
		# TODO: update the qwyz_item.
	end
	
	def destroy
		# TODO: implement deactivation of qwyz item.
		puts "------- destroy called. params = #{params.inspect}"
		@qwyz = Qwyz.find(params[:qwyz_id])
		# redirect_to qwyz_path(@qwyz)
		render 'qwyzs/show'
	end
	
	private
	
		def qwyz_item_params
			params.require(:qwyz_item).permit(:qwyz_id, 
					:description, :image)
		end
	
		def correct_user_and_qwyz
			# TODO: implement
		end
end


# TODO: implement