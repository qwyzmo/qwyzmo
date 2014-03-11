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
			qwyz_result = QwyzResult.new(@qwyz)
			expect(qwyz_result.total_vote_count).to eq 7
			
			expect(qwyz_result.qwyz_item(0).id).to eq 2
			expect(qwyz_result.qwyz_item(1).id).to eq 1
			expect(qwyz_result.qwyz_item(2).id).to eq 4
			expect(qwyz_result.qwyz_item(3).id).to eq 3
			
			expect(qwyz_result.vote_count(0)).to eq 3
			expect(qwyz_result.vote_count(1)).to eq 2
			expect(qwyz_result.vote_count(2)).to eq 2
			expect(qwyz_result.vote_count(3)).to eq 0
		end
	end
end
