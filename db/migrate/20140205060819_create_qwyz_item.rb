class CreateQwyzItem < ActiveRecord::Migration
	def change
		create_table :qwyz_items do |t|
			t.integer		:qwyz_id
			t.string		:description
			t.string		:image
			t.integer		:item_type, 		default: QwyzItem::TYPE[:image]
			t.integer		:status,	default: QwyzItem::STATUS[:active]

			t.timestamps
		end
		add_index :qwyz_items, :qwyz_id
	end
end
