
# TODO: consider renaming to ChoiceGenerator

# This is a utility class that provides the functionality for
# creating a pair of item ids, for a qwyz, that is not a repeat
# of the votes that have already been cast.

class ChoiceGenerator

	def max_choice_count(item_count)
		# return the number of vote pairs possible ( ignoring order )
		(item_count * (item_count - 1)) / 2
	end
	
	#
	def choice(votelist, item_id_list)
		if votelist.count == max_vote_pair_count(item_id_list.count)
			return [nil, nil]
		end
		# generate the all pairs map
		# remove each existing vote 
		# randomly choose two that remain, if possible.
		all_choices = all_choices_map(item_id_list)
		unvoted_choices = unvoted_choices_map(votelist, all_pairs)
		left_item_id = unvoted_choices.sample
		right_item_id = unvoted_choices[left].sample
		[left_item_id, right_item_id]
	end
	
	def all_choices_map(item_id_list)
		# for each id, put it in the map, 
		#   then put each of the rest in a submap. 
		#   we build a map of maps.  id>(id>true)
		
		# this is a map of maps, representing all allowable id pairs, 
		#   id1 => (id2 => true)  for all id1 and id2 in item_id_list
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
	
	def unvoted_choices_map(votelist, all_pairs)
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

















