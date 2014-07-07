class DbStats
	
	def self.query_num(table)
		sql = "select count(*) as num from #{table}"
		result = ActiveRecord::Base.connection.execute(sql)
		result.first["num"]
	end
	
	def self.recent_votes_per_ip
		Vote.where( created_at: 1.day.ago..Time.now ).group(:voter_ip_address).group(:voter_user_id).count
	end

	def self.votes_per_ip
		# sql = "select count(*), voter_user_id, voter_ip_address " +
					# "from votes group by voter_ip_address, voter_user_id order by voter_ip_address;"
		# result = ActiveRecord::Base.connection.execute(sql)
		Vote.all.order(:voter_ip_address).group(:voter_ip_address).group(:voter_user_id).count
	end
end