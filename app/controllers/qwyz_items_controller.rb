
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
			render_show_qwyz
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
		# TODO: for now just update the qwyz. later we may make items immutable.
		@qwyz_item = QwyzItem.find(params[:id])
		if @qwyz_item.update_attributes(qwyz_item_params)
			flash[:success] = "Qwyz item updated"
			render_show_qwyz
		else
			@title = "Edit Qwyz Item"
			render :edit
		end
	end
	
	def destroy
		@qwyz_item = QwyzItem.find(params[:id])
		@qwyz_item.status = QwyzItem::STATUS[:inactive]
		@qwyz_item.save
		render_show_qwyz
	end
	
	def activate
		@qwyz_item = QwyzItem.find(params[:id])
		@qwyz_item.status = QwyzItem::STATUS[:active]
		@qwyz_item.save
		@qwyz = Qwyz.find(@qwyz_item.qwyz_id)
		@title = "Inactive Qwyz Items"
		render "qwyzs/show_inactive_qwyz_items"
		
	end
	
	private
	
		def qwyz_item_params
			params.require(:qwyz_item).permit(:qwyz_id, 
					:description, :image)
		end
	
		def correct_user_and_qwyz
			# TODO: implement
		end
		
		def render_show_qwyz
			@qwyz = Qwyz.find(params[:qwyz_id])
			@title = 'View Qwyz'
			render 'qwyzs/show'
		end
end


