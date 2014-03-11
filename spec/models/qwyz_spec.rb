require 'spec_helper'

describe Qwyz do
	before do
		@user = create_test_user("n", "e@q.com", "passpass", "passpass")
		@qwyz = create_test_qwyz(@user.id, "n", "q", "d")
		@qitem1 = newitem(@qwyz.id, QwyzItem::STATUS[:active])
		@qitem2 = newitem(@qwyz.id, QwyzItem::STATUS[:active])
		@qitem3 = newitem(@qwyz.id, QwyzItem::STATUS[:active])
		@qitem4 = newitem(@qwyz.id, QwyzItem::STATUS[:active])
		@qitem5 = newitem(@qwyz.id, QwyzItem::STATUS[:inactive])
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
	
	describe "#active_item_count and #inactive_item_count" do
		
		it "returns correct number of active items" do
			expect(@qwyz.active_item_count).to eq 4
		end

		it "returns correct number of inactive items" do
			expect(@qwyz.inactive_item_count).to eq 1
		end
		
	end

	describe "#item" do
		it "finds valid items" do
			item = @qwyz.item(@qitem2.id)
			expect(item.id).to eq @qitem2.id
		end
		
		it "returns nil if item not found" do
			item = @qwyz.item(9999)
			expect(item).to be_nil
		end
	end
	
	describe "#item_id_to_item" do
		it "creates a map of the correct size" do
			map = @qwyz.item_id_to_item
			expect(map.count).to eq @qwyz.qwyz_items.count
		end
	end
	
	describe "#active_item_ids" do
		it "returns active item ids only" do
			ids = @qwyz.active_item_ids
			expect(ids.include?(@qitem1.id)).to be_true
			expect(ids.include?(@qitem2.id)).to be_true
			expect(ids.include?(@qitem3.id)).to be_true
			expect(ids.include?(@qitem4.id)).to be_true
			expect(ids.include?(@qitem5.id)).to be_false
		end
		
		it "returns empty array if no items" do
			qwyz = create_test_qwyz(@user.id, "n", "q", "d")
			ids = qwyz.active_item_ids
			expect(ids.count).to eq 0
		end
	end
	
	describe "#item_choice" do
		before do
			@qwyz = create_test_qwyz(@user.id, "n", "q", "d")
			# create 6 items for this qwyz
			@item_map = {}
			4.times do |i|
				qwyz_item = create_test_qwyz_item(@qwyz.id)
				@item_map[qwyz_item.id] = qwyz_item
			end
			# create a few test votes.
			k = @item_map.keys
			@votes = []
			@voter_id = 999
			@votes.push create_test_vote(@qwyz.id, k[0], k[1], k[0], @voter_id)
			@votes.push create_test_vote(@qwyz.id, k[1], k[2], k[1], @voter_id)
			@votes.push create_test_vote(@qwyz.id, k[2], k[3], k[3], @voter_id)
		end

		it "returns two items from the list, but not in votes list" do
			# lets use up all the remaining possible votes.
			3.times do
				left_item, right_item = @qwyz.item_choice(@voter_id, nil)
				vote = create_test_vote(@qwyz.id, left_item.id, right_item.id, 
						left_item.id, @voter_id)
				expect(vote_in_list?(vote, @votes)).to be_false
				expect(left_item.id).to_not eq right_item.id
				expect(left_item.qwyz_id).to eq @qwyz.id
				expect(right_item.qwyz_id).to eq @qwyz.id
				@votes.push(vote)
			end

			left_item, right_item = @qwyz.item_choice(@voter_id, nil)
			expect(left_item).to be_nil
			expect(right_item).to be_nil
		end
		
	end
	
	############################## helper methods
	
	def newqwyz(user_id, name, question, description)
		Qwyz.new(user_id: user_id, name: name, 
				question: question, description: description)
	end
	
	def newitem(qwyz_id, stat)
		create_test_qwyz_item(qwyz_id, "d", "/spec/fixtures/ruby.jpg", stat)
	end
	
	def votes_eq?(vote1, vote2)
		set1 = Set.new [vote1.left_item_id, vote1.right_item_id]
		set2 = Set.new [vote2.left_item_id, vote2.right_item_id]
		set1 == set2
	end
	
	def vote_in_list?(vote, votelist)
		votelist.each do |v|
			return true if votes_eq?(vote, v)
		end
		false
	end
		
end


