class CreateVotes < ActiveRecord::Migration
	def change
		create_table :votes do |t|
			t.integer	:qwyz_id
			t.integer	:left_item_id
			t.integer	:right_item_id
			t.integer	:chosen_item_id
			t.integer	:voter_user_id
			t.string	:voter_ip_address
			
			t.timestamps
		end
		add_index :votes, :qwyz_id
		add_index :votes, :left_item_id
		add_index :votes, :right_item_id
		add_index :votes, :voter_user_id
		add_index :votes, :voter_ip_address
	end
end
