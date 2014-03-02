require 'spec_helper'

describe Vote do
	
	describe "validations" do
		before do
			@votecount = Vote.count
		end
		
		it "fails to save if qwyz invalid" do
			vote = newvote()
			check_save_failed(vote, @votecount)
		end
		
		it "fails to save if any of the item ids are invalid" do
			
		end
		
		it "saves with valid fields" do
			
		end
	end
	
	describe "self.votelist" do
		before do
			@user1 = create_test_user("n1", "e1@q.com", "passpass", "passpass")
			@user2 = create_test_user("n2", "e2@q.com", "passpass", "passpass")
			@qwyz1 = create_test_qwyz(@user1.id, "n", "q", "d")
			@qwyz2 = create_test_qwyz(@user2.id, "n", "q", "d")
			@item1 = create_test_qwyz_item(@qwyz1.id)
			@item2 = create_test_qwyz_item(@qwyz2.id)
		end
		
		it "fetches only votes for correct qwyz, and user id" do
			Vote.find_by(qwyz_id, user_id, nil)
		end
		
		it "fetches only votes for correct qwyz, and ip" do
			
		end
	end
	
	def newvote()
		# TODO: implement
	end
	
end

# TODO: implement