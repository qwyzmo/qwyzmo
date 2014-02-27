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
	
	def item_id_list
		# TODO: implement
	end
	
	def item_choice(user_id, ip)
		votelist = Vote::votelist(id, user_id, ip)
		choice_gen = ChoiceGenerator.new
		left_item_id, right_item_id = choice_gen.choice(votelist, item_id_list)
	end
end





