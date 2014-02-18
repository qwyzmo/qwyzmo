
class QwyzItemsController < ApplicationController
	before_filter :authenticate
	before_filter :correct_user,
								:only => [:destroy, :edit, :update]

	def new
		@title = "Add a new Qwyz Item"
		@qwyz = Qwyz.find(params[:qwyz_id])
		@qwyz_item = QwyzItem.new
		@qwyz_item.qwyz_id = @qwyz.id
	end
	
	def create
		@qwyz = Qwyz.find(params[:qwyz_id])
		@qwyz_item = @qwyz.qwyz_items.build(qwyz_item_params)
		if @qwyz_item.save
			flash[:success] = "Qwyz item created."
			render_show_qwyz @qwyz.id
		else
			@title = "Add a new Qwyz item"
			render :new
		end
	end
	
	def show
		@qwyz_item = QwyzItem.find(params[:id])
		@qwyz = Qwyz.find(@qwyz_item.qwyz_id)
		@title = "View Qwyz Item"
	end
	
	def edit
		@title = "Edit Qwyz Item"
		@qwyz_item = QwyzItem.find(params[:id])
		@qwyz = Qwyz.find(@qwyz_item.qwyz_id)
	end
	
	def update
		# TODO: for now just update the qwyz. later we may make items immutable.
		@qwyz_item = QwyzItem.find(params[:id])
		@qwyz = Qwyz.find(@qwyz_item.qwyz_id)
		if @qwyz_item.update_attributes(qwyz_item_params)
			flash[:success] = "Qwyz item updated"
			render_show_qwyz(@qwyz_item.qwyz_id)
		else
			@title = "Edit Qwyz Item"
			render :edit
		end
	end
	
	def destroy
		@qwyz_item = QwyzItem.find(params[:id])
		@qwyz_item.status = QwyzItem::STATUS[:inactive]
		@qwyz_item.save
		render_show_qwyz(@qwyz_item.qwyz_id)
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
	
		def correct_user
			begin
				@qwyz_item = QwyzItem.find(params[:id])
				@qwyz = Qwyz.find(@qwyz_item.qwyz_id)
				redirect_to users_url if current_user.id != @qwyz.user_id
			rescue
				redirect_to users_url
			end
		end
		
		def render_show_qwyz(qwyz_id)
			@qwyz = Qwyz.find(qwyz_id)
			@title = 'View Qwyz'
			render 'qwyzs/show'
		end
end


