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
		# TODO add status to qwyz db. add status codes: active, inactive
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
	
	def next_unvoted_item_pair(user, ip, votelist)
		users_votes = Vote.get_votes_by_voter(id, current_user, ip)
		unvoted_item_pair(users_votes)
	end

	# gets the next pair of items that havent been voted on by the given user.
	def unvoted_item_pair(votelist)
		# find the items that have not been voted on, randomly pick two.
		# create a map of id to items. remove all the left and right items from the votes.
		voted_item_ids = {}
		votelist.each do |vote|
			voted_item_ids.put(vote.left_item_id, true)
			voted_item_ids.put(vote.right_item_id, true)
		end
		unvoted_items = []
		qwyz_items.each do |item|
			if ! voted_item_ids[item.id]
				unvoted_items.add item
			end
		end
		unvoted_items.sample 2
	end
end





