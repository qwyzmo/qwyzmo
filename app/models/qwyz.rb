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
		left_item_id, right_item_id = ChoiceGenerator.choice(votelist, active_item_ids)
		return [item(left_item_id), item(right_item_id)]
	end

	# return list of qwyz ids from the qwyzs.
	def self.user_id_list(qwyz_list)
		id_list = []
		qwyz_list.each do |qwyz|
			id_list.push(qwyz.user_id)
		end
		id_list
	end

	# returns a map of qwyz id to user name of the qwyz's creator
	def self.id2author(qwyz_list)
		return {} if qwyz_list.blank?
		author_list = User.find(Qwyz.user_id_list(qwyz_list))
		user_id2name = {}
		author_list.each do |author|
			user_id2name[author.id] = author.name
		end
		qwyz_id2user_name = {}
		qwyz_list.each do |qwyz|
			qwyz_id2user_name[qwyz.id] = user_id2name[qwyz.user_id]
		end
		qwyz_id2user_name
	end
	
	# return the total possible votes on active items
	def total_possible_vote_count
		ChoiceGenerator.max_choice_count(active_item_ids.count)
	end

	# returns the remaining votes for active items.
	def remaining_vote_count(current_user_id, current_user_ip)
		votes = Vote.votelist(self.id, current_user_id, current_user_ip)
		# filter out the votes for inactive items.
		active_ids = active_item_ids()
		active_votes = votes.find_all do |vote|
			active_ids.include?(vote.chosen_item_id)
		end
		ChoiceGenerator.max_choice_count(self.active_item_count) - active_votes.count
	end
	
	# returns the previous and next item ids that are active. 
	# returns nils if there is none
	def previous_next_active_item_ids(item_id)
		return [nil,nil] if item_id.nil?
		ids = active_item_ids
		item_index = ids.find_index(item_id)
		return [nil, nil] if item_index.nil?
		previous_id = item_index == 0 ? nil : ids[item_index - 1]
		next_id = item_index == ids.length - 1 ? nil : ids[item_index + 1]
		[previous_id, next_id]
	end
end








