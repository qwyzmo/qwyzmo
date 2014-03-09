require 'spec_helper'

describe Vote do
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
	
	describe "validations" do
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
		
		it "fails validation if not unique: {chosen, left, right, user_id, ip}" do
			# TODO implement
			pending
		end

		it "passes validation with valid fields" do
			vote = newvote(@qwyz1.id, @item1a.id, @item1b.id, @item1a.id)
			expect(vote.valid?).to be_true
		end
	end
	
	describe "self.votelist" do
		before do
			@ip = "1.2.3.4"
			@vote1a = create_test_vote(@qwyz1.id, @item1a.id, @item1b.id, @item1a.id, @user2.id)
			@vote1b = create_test_vote(@qwyz1.id, @item1c.id, @item1b.id, @item1c.id, @user2.id)
			@vote1c = create_test_vote(@qwyz1.id, @item1a.id, @item1c.id, @item1c.id, @user1.id)
			@vote1d = create_test_vote(@qwyz1.id, @item1c.id, @item1b.id, @item1c.id, nil, 			@ip)
			@vote2a = create_test_vote(@qwyz2.id, @item2a.id, @item2b.id, @item2a.id, @user1.id)
			@vote2b = create_test_vote(@qwyz2.id, @item2a.id, @item2b.id, @item2b.id, nil, 			@ip)
		end
		
		it "fetches only votes for correct qwyz, and user id" do
			votes = Vote.votelist(@qwyz1.id, @user2.id, nil)
			expect(votes.count).to eq 2
			expect(votes[0].id).to_not eq votes[1].id
			expect(votes[0].qwyz_id).to eq @qwyz1.id
			expect(votes[1].qwyz_id).to eq @qwyz1.id
			expect(votes[0].voter_user_id).to eq @user2.id
			expect(votes[1].voter_user_id).to eq @user2.id
		end
		
		it "fetches only votes for correct qwyz, and ip" do
			votes = Vote.votelist(@qwyz2.id, nil, @ip)
			expect(votes.count).to eq 1
			expect(votes[0].qwyz_id).to eq @qwyz2.id
			expect(votes[0].voter_ip_address).to eq @ip
		end
		
		it "returns empty array if no votes match" do
			votes = Vote.votelist(7777, 99999, nil)
			expect(votes).to_not be_nil
			expect(votes.count).to be 0
		end
	end
	
	def newvote(qwyz_id, left_item_id, right_item_id, chosen_item_id)
		Vote.new(qwyz_id: qwyz_id, left_item_id: left_item_id, 
				right_item_id: right_item_id, chosen_item_id: chosen_item_id)
	end
	
end

