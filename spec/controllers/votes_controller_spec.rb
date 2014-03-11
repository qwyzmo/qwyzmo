require 'spec_helper'

describe VotesController do
	render_views
	
	before do
		@user = create_test_user("n0", "n0@e.c", "password", "password")
		@qwyz = create_test_qwyz(@user.id, "name", "question", "desc")
	end
	
	describe "#new" do
		before do
			@item1a = create_test_qwyz_item(@qwyz.id)
			@item1b = create_test_qwyz_item(@qwyz.id)
			@item1c = create_test_qwyz_item(@qwyz.id)
		end
		
		describe "not all votes have been cast" do
			
			it "sets title, qwyz, renders new, sets left and right items" do
				get :new, qwyz_id: @qwyz.id
				
				expect(response).to render_template :new
				expect(response.body).to have_title "Vote"
				
				qwyz 				=		assigns(:qwyz)
				left_item 	=		assigns(:left_item)
				right_item	=		assigns(:right_item)
				vote 				= 	assigns(:vote)
				
				expect(qwyz.id).to eq(@qwyz.id)
				expect(@qwyz.item(left_item.id)).to_not be_nil
				expect(@qwyz.item(right_item.id)).to_not be_nil
				expect(vote).to_not be_nil
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

				expect(response).to render_template :index
				expect(response.body).to have_title "Qwyz Vote Summary"
				
				result = assigns(:qwyz_result)
				
				expect(result).to_not be_nil
				# TODO: test index creating the attributes to summarize the votes
			end
		end
	end
	
	describe "#create" do
		
		it "records the vote" do
			pending
		end
		
		it "renders :new if not all votes cast" do
			pending
		end
		
		it "renders index if all votes cast" do
			pending
		end
		
		pending
	end

	describe "#index" do
		pending
	end
end




