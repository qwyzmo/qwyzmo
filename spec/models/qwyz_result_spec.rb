require 'spec_helper'

describe QwyzResult do
	before do
		@user 	= create_test_user("n", "e@q.com", "passpass", "passpass")
		@qwyz 	= create_test_qwyz(@user.id, "n", "q", "d")
		@qwyz2 	= create_test_qwyz(@user.id, "n", "q", "d")
		@qitem1 = create_test_qwyz_item(@qwyz.id)
		@qitem2 = create_test_qwyz_item(@qwyz.id)
		@qitem3 = create_test_qwyz_item(@qwyz.id)
		@qitem4 = create_test_qwyz_item(@qwyz.id)
		
		@vote1 = create_test_vote(@qwyz.id, @qitem1.id, @qitem2.id, @qitem2.id, @user.id)
		@vote2 = create_test_vote(@qwyz.id, @qitem2.id, @qitem3.id, @qitem2.id, @user.id)
		@vote3 = create_test_vote(@qwyz.id, @qitem3.id, @qitem4.id, @qitem4.id, @user.id)
		@vote4 = create_test_vote(@qwyz.id, @qitem4.id, @qitem1.id, @qitem4.id, @user.id)
		@vote5 = create_test_vote(@qwyz.id, @qitem3.id, @qitem1.id, @qitem1.id, @user.id)
		
		@vote6 = create_test_vote(@qwyz.id, @qitem2.id, @qitem1.id, @qitem1.id, @user.id)
		@vote7 = create_test_vote(@qwyz.id, @qitem3.id, @qitem2.id, @qitem2.id, @user.id)
	end

	describe "#initialize" do
		it "fetches the correct results" do
			qwyz_result = QwyzResult.new(@qwyz, @user.id, nil)
			expect(qwyz_result.total_vote_count).to eq 7
			
			item_id_list = [2, 1, 4, 3]
			vote_count_list = [3, 2, 2, 0]
			expect(qwyz_result.count).to eq 4
			index = 0
			qwyz_result.each do |item, vote_count, user_vote_count|
				expect(item.id).to 					eq item_id_list[index]
				expect(vote_count).to				eq vote_count_list[index]
				expect(user_vote_count).to	eq vote_count_list[index]
				index += 1
			end
		end
	end
end
