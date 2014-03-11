
# Represents the results of the votes cast for a given qwyz.
class QwyzResult
	attr_accessor :total_vote_count
	
	def initialize(qwyz)
		result = query_result(qwyz.id)
		@total_vote_count, @item_vcount_list = 
					item_vote_count_list(qwyz.item_id_to_item.clone, result)
	end
	
	def qwyz_item(index)
		@item_vcount_list[index][0]
	end
	
	def vote_count(index)
		@item_vcount_list[index][1]
	end
	
	def item_count
		@item_vcount_list.count
	end
	
	private
	
	def query_result(qwyz_id)
		sql = "select chosen_item_id, count(*) as vote_count from votes " + 
						"where qwyz_id = #{qwyz_id}  group by chosen_item_id " + 
						"order by vote_count desc"
		conn = ActiveRecord::Base.connection
		ActiveRecord::Base.connection.execute(sql)
	end
	
	def item_vote_count_list(item_map, query_result)
		item_vcount_list = []
		total_vote_count = 0
		query_result.each do |row|
			cur_item = item_map[row["chosen_item_id"]]
			item_vcount_list.push([cur_item, row["vote_count"]])
			item_map.delete(row["chosen_item_id"])
			total_vote_count += row["vote_count"]
		end
		item_map.each do |id, item|
			item_vcount_list.push([item, 0])
		end
		[total_vote_count, item_vcount_list]
	end
end






