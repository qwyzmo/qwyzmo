
# Represents the results of the votes cast for a given qwyz.
class QwyzResult
	attr_accessor :total_vote_count, :item_count
	
	# for each item in qwyz, need to get all votes and tally them.
	# then order the items from best to worst.
	
	# how to make this scalable and more efficient? 
	#			- could store the results in a table, with dates, and use that to reduce 
	# 			future calculations
	# 		- also could paginate the results: show top 10, then 10 at a time.
	# 		- also could design the sql queries to summarize for us!

	def initialize(qwyz)
		# need to get all the votes for each qwyz item.
		sql = "select chosen_item_id, count(*) as vote_count from votes " + 
						"where qwyz_id = #{qwyz.id}  group by chosen_item_id"
		conn = ActiveRecord::Base.connection
		result = ActiveRecord::Base.connection.execute(sql)
		puts "-----> result = #{result}"
		# build map of item id to vote count
		@vote_map = {}
		@total_vote_count = 0
		result.each do |row|
			@vote_map[row["chosen_item_id"]] = row["vote_count"]
			@total_vote_count += row["vote_count"]
		end
		puts "=====> vote map = #{@vote_map.inspect}"
		puts "=====> total votes = #{@total_vote_count}"
		@item_count = qwyz.qwyz_items.count
		# TODO create an list of items ordered from highest to lowest percent of votes.
		#   also create a list of percentage of votes, highest to lowest.
	end
	
	def qwyz_item(index)
		@qwyz_items[index] 
	end
	
	def vote_percentage(index)
		@vote_percentages[index]
	end

end

# TODO implement

# how to use the results?
#  need to display list of qwyz items, in order, highest votes to lowest.
#  need an array of qwyz items and votes for that item, plus a total votes cast.