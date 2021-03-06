require 'spec_helper'

describe VotesController do
	render_views
	
	before do
		@user = create_test_user("n0", "n0@e.c", "password", "password")
		@qwyz = create_test_qwyz(@user.id, "name", "question", "desc")
		@item1a = create_test_qwyz_item(@qwyz.id)
		@item1b = create_test_qwyz_item(@qwyz.id)
		@item1c = create_test_qwyz_item(@qwyz.id)
		@item1d = create_test_qwyz_item(@qwyz.id, "d", "/spec/fixtures/ruby.jpg", 
							QwyzItem::STATUS[:inactive])
	end
	
	describe "#new" do
		describe "not all votes have been cast" do
			before do
				@vote1 = create_test_vote(@qwyz.id, @item1d.id, @item1b.id, @item1d.id, @user.id)
				test_sign_in(@user)
			end
			
			it "sets title, qwyz, renders new, sets left and right items" do
				get :new, qwyz_id: @qwyz.id
				
				qwyz 									= assigns(:qwyz)
				left_item 						= assigns(:left_item)
				right_item						= assigns(:right_item)
				vote 									= assigns(:vote)
				votes_til_results 		= assigns(:votes_til_results)
				show_results 					= assigns(:show_results)
				votes_cast						= assigns(:votes_cast)
				total_possible_votes	= assigns(:total_possible_votes)
				
				expect(response).to render_template :new
				expect(response.body).to have_title "Vote"
				expect(qwyz.id).to eq(@qwyz.id)
				expect(@qwyz.item(left_item.id)).to_not be_nil
				expect(@qwyz.item(right_item.id)).to_not be_nil
				expect(vote).to_not be_nil
				expect(votes_til_results).to eq 3
				expect(show_results).to be_false
				
				expect(votes_cast).to eq 0
				expect(total_possible_votes).to eq 3
				
			end
		end

		describe "no more votes for this user and qwyz" do
			before do
				@vote1 = create_test_vote(@qwyz.id, @item1a.id, @item1b.id, @item1a.id, @user.id)
				@vote1 = create_test_vote(@qwyz.id, @item1a.id, @item1c.id, @item1a.id, @user.id)
				@vote1 = create_test_vote(@qwyz.id, @item1c.id, @item1b.id, @item1b.id, @user.id)
				test_sign_in(@user)
			end
			
			it "sets title, sets qwyz, and renders qwyz summary" do
				get :new, qwyz_id: @qwyz.id

				result 								= assigns(:qwyz_result)
				votes_cast						= assigns(:votes_cast)
				total_possible_votes	= assigns(:total_possible_votes)
				
				expect(response).to render_template :index
				expect(response.body).to have_title "Qwyz Vote Summary"
				expect(result).to_not be_nil
				expect(result.count).to eq 4
				expect(result.total_vote_count).to eq 3
				
				expect(votes_cast).to eq 3
				expect(total_possible_votes).to eq 3
			end
		end
	end
	
	describe "#create" do
		before do
			@vote1 = create_test_vote(@qwyz.id, @item1a.id, @item1b.id, @item1a.id, @user.id)
			test_sign_in(@user)
		end
		
		it "records the vote, renders :new" do
			db_vote_count = Vote.count
			post :create, { 	qwyz_id: @qwyz.id, left_item_id: 	@item1b.id,
											 		right_item_id:	@item1c.id, commit:	@item1b.id}
			expect(response).to render_template :new 
			expect(Vote.count).to eq(db_vote_count + 1)
		end
	end

	describe "#index" do
		before do
		end
		
		it "sets title, qwyz, qwyz_result, and renders index" do
			get :index, qwyz_id: @qwyz.id
			
			qwyz 									= assigns(:qwyz)
			qwyz_result 					= assigns(:qwyz_result)
			author 								= assigns(:author)
			remaining_vote_count	= assigns(:remaining_vote_count)
			votes_cast						= assigns(:votes_cast)
			total_possible_votes	= assigns(:total_possible_votes)
			# TODO add tests for vars to turn on link to finish qwyz.
			
			expect(response.body).to have_title "Qwyz Vote Summary"
			expect(response).to render_template :index
			
			expect(qwyz.id).to eq @qwyz.id
			expect(qwyz_result.count).to eq 4
			expect(author.id).to eq qwyz.user_id
			
			expect(remaining_vote_count).to eq 3
			expect(votes_cast).to eq 0
			expect(total_possible_votes).to eq 3
		end
		
	end
end




