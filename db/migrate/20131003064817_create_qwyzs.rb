class CreateQwyzs < ActiveRecord::Migration
	def self.up
		create_table :qwyzs do |t|
				t.integer	 :user_id
				t.string		:name
				t.string		:question
				t.string		:description

			t.timestamps
		end
		add_index :qwyzs, :user_id
	end

	def self.down
		drop_table :qwyzs
	end
end
