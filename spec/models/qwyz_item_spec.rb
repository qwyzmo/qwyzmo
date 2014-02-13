require 'spec_helper'

describe QwyzItem do
	before do
		@user = create_test_user("n", "e@q.com", "passpass", "passpass")
		@qwyz = create_test_qwyz(@user.id, "n", "q", "d")
	end
	
	describe "validations" do
		before do
			@qcount = QwyzItem.count
		end
		
		it "fails to save if qwyz_id nil" do
			item = QwyzItem.new(qwyz_id: nil, description: "d2")
			save_result = item.save
			expect(save_result).to be_false
			expect(QwyzItem.count).to eq @qcount
		end
		
		it "saves with valid fields" do
			item = QwyzItem.new(qwyz_id: @qwyz.id, description: 'd3')
			save_result = item.save
			expect(save_result).to be_true
			expect(QwyzItem.count).to eq @qcount + 1
		end
	end
	
	describe "#active?" do
		it "returns true if active, false otherwize" do
			item = QwyzItem.new
			item.status = QwyzItem::STATUS[:active]
			expect(item.active?).to eq true
			item.status = QwyzItem::STATUS[:inactive]
			expect(item.active?).to eq false
		end
	end
	
	describe "#inactive?" do
		it "returns true if inactive, false otherwize" do
			item = QwyzItem.new
			item.status = QwyzItem::STATUS[:inactive]
			expect(item.inactive?).to eq true
			item.status = QwyzItem::STATUS[:active]
			expect(item.inactive?).to eq false
		end
	end
	
end


