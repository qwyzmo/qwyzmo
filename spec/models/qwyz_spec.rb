require 'spec_helper'

describe Qwyz do
	before do
		@user = create_test_user("n", "e@q.com", "passpass", "passpass")
	end
	
	describe "validations" do
		before do
			@qwyzcount = Qwyz.count
		end
		
		it "fails to save if user_id nil" do
			qwyz = newqwyz(nil, "n", "q", "d")
			check_save_failed(qwyz, @qwyzcount)
		end

		it "fails to save if name empty" do
			qwyz = newqwyz(@user.id, "", "q", "d")
			check_save_failed(qwyz, @qwyzcount)
		end
		
		it "fails to save if question empty" do
			qwyz = newqwyz(@user.id, "n", "", "d")
			check_save_failed(qwyz, @qwyzcount)
		end
		
		it "fails to save if user_id invalid" do
			qwyz = newqwyz(9999, "n", "q", "d")
			check_save_failed(qwyz, @qwyzcount)
		end
		
		it "saves with valid fields" do
			qwyz = newqwyz(@user.id, "n", "q", "d")
			save_result = qwyz.save
			expect(save_result).to be_true
			expect(Qwyz.count).to eq @qwyzcount + 1
		end
	end
	
	describe "counting active and inactive items" do
		before do
			@qwyz = create_test_qwyz(@user.id, "n", "q", "d")
			qitem1 = newitem(@qwyz.id, QwyzItem::STATUS[:active])
			qitem2 = newitem(@qwyz.id, QwyzItem::STATUS[:active])
			qitem3 = newitem(@qwyz.id, QwyzItem::STATUS[:active])
			qitem4 = newitem(@qwyz.id, QwyzItem::STATUS[:inactive])
			qitem5 = newitem(@qwyz.id, QwyzItem::STATUS[:inactive])
		end
		
		it "returns correct number of active items" do
			expect(@qwyz.active_item_count).to eq 3
		end

		it "returns correct number of inactive items" do
			expect(@qwyz.inactive_item_count).to eq 2
		end
	end
	
	describe "#item_choice" do
		before do
			@qwyz = create_test_qwyz(@user.id, "n", "q", "d")
			# create 6 items for this qwyz
			@item_map = {}
			6.times do |i|
				qwyz_item = create_test_qwyz_item(@qwyz.id)
				@item_map[qwyz_item.id] = qwyz_item
			end
			# create a few test votes.
			k = @item_map.keys
			@votes = []
			@votes.push create_test_vote(@qwyz.id, k[0], k[1], k[0], 999)
			@votes.push create_test_vote(@qwyz.id, k[1], k[2], k[0], 999)
			@votes.push create_test_vote(@qwyz.id, k[2], k[3], k[0], 999)
			# @votes.push create_test_vote(@qwyz.id, k[3], k[4], k[0], 999)
			# @votes.push create_test_vote(@qwyz.id, k[4], k[5], k[0], 999)
			# @votes.push create_test_vote(@qwyz.id, k[5], k[0], k[0], 999)
			# @votes.push create_test_vote(@qwyz.id, k[0], k[3], k[0], 999)
		end

		it "returns two items from the list" do
			pending
		end
		
	end
	
	describe "#item_choice" do
		pending
	end
	
	############################## helper methods
	
	def newqwyz(user_id, name, question, description)
		Qwyz.new(user_id: user_id, name: name, 
				question: question, description: description)
	end
	
	def newitem(qwyz_id, stat)
		create_test_qwyz_item(qwyz_id, "d", "/spec/fixtures/ruby.jpg", stat)
	end
end


