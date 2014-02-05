class CreateQwyzItem < ActiveRecord::Migration
	def change
		create_table :qwyz_items do |t|
			t.integer		:qwyz_id
			t.string		:description
			t.string		:image
			t.integer		:type
			t.integer		:status

			t.timestamps
		end
		add_index :qwyz_items, :qwyz_id
	end
end
