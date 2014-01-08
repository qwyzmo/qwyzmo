class AddStatusToUsers < ActiveRecord::Migration
	def change
		add_column :users, :status, :integer, :default => User::STATUS[:pending_email]
	end
end
