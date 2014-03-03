require 'spec_helper'

describe Vote do
	
	describe "validations" do
		before do
			@votecount = Vote.count
			@user1 = create_test_user("n1", "e1@q.com", "passpass", "passpass")
			@user2 = create_test_user("n2", "e2@q.com", "passpass", "passpass")
			@qwyz1 = create_test_qwyz(@user1.id, "n", "q", "d")
			@qwyz2 = create_test_qwyz(@user2.id, "n", "q", "d")
			@item1a = create_test_qwyz_item(@qwyz1.id)
			@item1b = create_test_qwyz_item(@qwyz1.id)
			@item1c = create_test_qwyz_item(@qwyz1.id)
			@item2a = create_test_qwyz_item(@qwyz2.id)
			@item2b = create_test_qwyz_item(@qwyz2.id)
		end
		
		it "fails validation if qwyz not in db." do
			vote = newvote(9999, @item1a.id, @item1b.id, @item1a.id)
			expect(vote.valid?).to be_false
		end

		it "fails validation if any of the item ids are not in db" do
			vote = newvote(@qwyz1.id, @item1a.id, 99999, @item1a.id)
			expect(vote.valid?).to be_false
		end
		
		it "fails validation if any of the items do not belong to the qwyz" do
			vote = newvote(@qwyz1.id, @item2a.id, @item1a.id, @item1a.id)
			expect(vote.valid?).to be_false
		end
		
		it "fails validation if chosen is not = left or right item" do
			vote = newvote(@qwyz1.id, @item1a.id, @item1b.id, @item1c.id)
			expect(vote.valid?).to be_false
		end
		
		it "fails validation if left and right item ids are =" do
			vote = newvote(@qwyz1.id, @item1a.id, @item1a.id, @item1a.id)
			expect(vote.valid?).to be_false
		end

		it "passes validation with valid fields" do
			vote = newvote(@qwyz1.id, @item1a.id, @item1b.id, @item1a.id)
			expect(vote.valid?).to be_true
		end
	end
	
	describe "self.votelist" do
		before do
		end
		
		it "fetches only votes for correct qwyz, and user id" do
			# Vote.find_by(qwyz_id, user_id, nil)
			pending
		end
		
		it "fetches only votes for correct qwyz, and ip" do
			pending
		end
	end
	
	def newvote(qwyz_id, left_item_id, right_item_id, chosen_item_id)
		Vote.new(qwyz_id: qwyz_id, left_item_id: left_item_id, 
				right_item_id: right_item_id, chosen_item_id: chosen_item_id)
	end
	
end

