class DbStats
	
	def self.query_num(table)
		sql = "select count(*) as num from #{table}"
		conn = ActiveRecord::Base.connection
		result = ActiveRecord::Base.connection.execute(sql)
		result.first["num"]
	end
end