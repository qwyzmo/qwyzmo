
# This is a utility class that provides the functionality for
# creating a pair of item ids, for a qwyz, that is not a repeat
# of the votes that have already been cast.
class ChoiceGenerator
	
	def self.max_choice_count(item_count)
		# return the number of vote pairs possible ( ignoring order )
		(item_count * (item_count - 1)) / 2
	end
	
	# creates an order pair of item ids, given all votes cast so far, and a list
	#  of all available item ids.
	def self.choice(votelist, item_id_list)
		votelist = [] if votelist.nil?
		if item_id_list.blank? || votelist.count == max_choice_count(item_id_list.count)
			return [nil, nil]
		end
		all_choices = all_choices_map(item_id_list)
		remove_votes_from_choices(votelist, all_choices)
		# pick a random left and right item id.
		left_item_id = all_choices.keys.sample
		right_item_id = all_choices[left_item_id].keys.sample
		[left_item_id, right_item_id]
	end
	
	# build a map of item id to map of item ids. representing all possible 
	#  (id1,id2) pairs
	#   id1 => (id2 => true)  for all id1 and id2 in item_id_list where id1 != id2
	def self.all_choices_map(item_id_list)
		map = {}
		item_id_list.each do |left|
			item_id_list.each do |right|
				if map[left].nil?
					map[left] = {}
				end
				if left != right
					map[left][right] = true
				end
			end
		end
		map
	end
	
	# removes the votes from the all_pairs map
	def self.remove_votes_from_choices(votelist, all_pairs)
		# for each vote in votelist, remove it from the @all_pairs_map
		#  creating a new map of unused item pairings.
		votelist.each do |item|
			all_pairs[item.left_item_id].delete(item.right_item_id)
			all_pairs[item.right_item_id].delete(item.left_item_id)
			if all_pairs[item.left_item_id].count == 0
				all_pairs.delete(item.left_item_id)
			end
			if all_pairs[item.right_item_id].count == 0
				all_pairs.delete(item.right_item_id)
			end
		end
	end
	
end

















