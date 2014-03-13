require 'spec_helper'

describe "vote pages" do
	subject { page }
	
	before do
		# create a qwyz with 3 items, and 2 votes. need 2 users; qwyz creator and voter.
		@user = create_test_user("n0", "n0@e.c", "password", "password")
		@qwyz = create_test_qwyz(@user.id, "name", "question", "desc")
		@item1a = create_test_qwyz_item(@qwyz.id)
		@item1b = create_test_qwyz_item(@qwyz.id)
		@item1c = create_test_qwyz_item(@qwyz.id)
		
		@voter = create_test_user("voter", "v@e.c", "password", "password")
	end

	describe "click browse qwyz and go to vote page" do
		before do 
			visit root_path
			click_link "browse"
		end
		
		it { should have_title "Vote"}
		
		describe "cast a vote for an item." do
			before do
				click_button("left_img")
			end
			
			it { should have_title "Vote"}
			
			describe "cast two more votes, completing this qwyz" do
				before do
					click_button("left_img")
					click_button("left_img")
				end
				
				it { should have_title "Qwyz Vote Summary"}
			end
		end
	end
end





