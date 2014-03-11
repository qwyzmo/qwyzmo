class Qwyz < ActiveRecord::Base

	belongs_to :user
	has_many :qwyz_items

	validates :name,			:presence => true, :length => {:maximum => 100}
	validates :question,	:presence => true, :length => {:maximum => 200}
	validates :user_id,	:presence => true
	validates_presence_of :user
	
	# TODO fix default ordering of qwyzs
	# default_scope :order => 'qwyzs.created_at DESC'


	# deactivate the qwyz; qwyzs are never destroyed.
	def destroy
		# TODO deactivate qwyz
		#     add status to qwyz db. add status codes: active, inactive
	end
	
	def active_item_count
		return 0 if qwyz_items.nil?
		count = 0
		qwyz_items.each do |item|
			count +=1 if item.active?
		end
		count
	end
	
	def inactive_item_count
		return 0 if qwyz_items.nil?
		count = 0
		qwyz_items.each do |item|
			count +=1 if item.inactive?
		end
		count
	end
	
	# first call; build a hash of items by id and keep it around.
	def item(id)
		return nil if id.nil?
		return item_id_to_item[id]
	end
	
	# this method lazily builds the map of item ids to items.
	# the item id to item attribute should only be accessed 
	# in this method. All other methods in this class should 
	# call this method to use that map.
	def item_id_to_item
		if @_item_map.nil?
			@_item_map = {}
			qwyz_items.each do |item|
				@_item_map[item.id] = item
			end
		end
		return @_item_map
	end
	
	def active_item_ids
		ids = []
		qwyz_items.each do |item|
			ids.push(item.id) if item.active?
		end
		return ids
	end
	
	# returns a pair of items that have not been voted on side by side
	#   by the user designated by either id or ip. exclude inactive items also.
	def item_choice(user_id, ip)
		votelist = Vote::votelist(id, user_id, ip)
		choice_gen = ChoiceGenerator.new
		left_item_id, right_item_id = choice_gen.choice(votelist, active_item_ids)
		return [item(left_item_id), item(right_item_id)]
	end
end





