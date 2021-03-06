# Represents the results of the votes cast for a given qwyz.
class QwyzResult
	include Enumerable
	
	attr_accessor :total_vote_count
	ITEM_INDEX = 0
	VOTE_COUNT_INDEX = 1
	USER_VOTE_COUNT_INDEX = 2
	
	def initialize(qwyz, user_id, ip)
		result = query_result(qwyz.id)
		
		# need the votelist for user_id, ip; from that can build 
		#  a third
		
		vote_map = Vote.vote_map(qwyz.id, user_id, ip)
		@total_vote_count, @item_vcount_list = 
					item_vote_count_list(qwyz.item_id_to_item.clone, result, vote_map)
	end
	
	def each(&block)
		@item_vcount_list.each do |item_vcount|
			block.call(	item_vcount[ITEM_INDEX], 
									item_vcount[VOTE_COUNT_INDEX],
									item_vcount[USER_VOTE_COUNT_INDEX])
		end
	end
	
	########################################## private methods.
	private
	
	def query_result(qwyz_id)
		sql = "select chosen_item_id, count(*) as vote_count from votes " + 
						"where qwyz_id = #{qwyz_id}  group by chosen_item_id " + 
						"order by vote_count desc"
		conn = ActiveRecord::Base.connection
		ActiveRecord::Base.connection.execute(sql)
	end
	
	def item_vote_count_list(item_map, query_result, vote_map)
		item_vcount_list = []
		total_vote_count = 0
		query_result.each do |row|
			cur_chosen_id = row["chosen_item_id"].to_i
			cur_item = item_map[cur_chosen_id]
			user_vcount = vote_map[cur_chosen_id].nil? ? 0 : vote_map[cur_chosen_id].count
			item_vcount_list.push([cur_item, row["vote_count"].to_i, user_vcount ])
			item_map.delete(row["chosen_item_id"].to_i)
			total_vote_count += row["vote_count"].to_i
		end
		item_map.each do |id, item|
			item_vcount_list.push([item, 0, 0])
		end
		[total_vote_count, item_vcount_list]
	end
end






