require 'spec_helper'

describe ChoiceGenerator do
	
	describe "#max_choice_count" do
		it "calculates the correct number" do
			expect(ChoiceGenerator.max_choice_count(5)).to eq 10
			expect(ChoiceGenerator.max_choice_count(3)).to eq 3
			expect(ChoiceGenerator.max_choice_count(4)).to eq 6			
		end
	end
	
	describe "#all_choices_map" do
		before do
			@item_id_list = [1,2,3,4,5,6,7]
			@map = ChoiceGenerator.all_choices_map(@item_id_list)
		end
		
		it "creates a map with correct number of entries" do
			expect(@map.count).to eq @item_id_list.count
		end
		
		it "creates a map with correct sized sub maps." do
			@item_id_list.each do |id|
				expect(@map[id].count).to eq(@item_id_list.count - 1)
			end
		end
		
		it "has no submap with same id as key pointing to submap." do
			@item_id_list.each do |id|
				expect(@map[id][id]).to be_nil
			end
		end
		
		describe "#remove_votes_from_choices" do
			before do
				@votelist = [vote(1,2), vote(7,2), vote(4,5)]
				@full_map_count = choice_map_count(@map)
				ChoiceGenerator.remove_votes_from_choices(@votelist, @map)
			end
			
			it "removes all the votes in the list and their reflections" do
				@votelist.each do |vote|
					expect(@map[vote.left_item_id][vote.right_item_id]).to be_nil
					expect(@map[vote.right_item_id][vote.left_item_id]).to be_nil
				end
				expect(choice_map_count(@map)).to eq(@full_map_count - @votelist.count * 2) 
			end
			
		end # remove_votes_from_choices
	end # all_choices_map
	
	describe "#choices" do
		before do
			
		end
		
		it "generates a pair that is not in the list of votes" do
			votelist = [vote(8,6), vote(7,6), vote(5,8)]
			id_list = [5,6,7,8]
			left, right = ChoiceGenerator.choice(votelist, id_list)
			newvote = vote(left, right)
			newvote_reflected = vote(right, left)
			votelist.each do |vote|
				expect(vote_equal?(newvote, vote)).to be_false 
				expect(vote_equal?(newvote_reflected, vote)).to be_false 
			end
		end
		
		it "returns nil if all votes cast" do
			votelist = [vote(5,6), vote(5,7), vote(6,7)]
			id_list = [5,6,7]
			left, right = ChoiceGenerator.choice(votelist, id_list)
			expect(left).to be_nil
			expect(right).to be_nil
		end
		
		it "returns nils if id list is nil" do
			votelist = [vote(5,6), vote(5,7), vote(6,7)]
			id_list = nil
			left, right = ChoiceGenerator.choice(votelist, id_list)
			expect(left).to be_nil
			expect(right).to be_nil
		end
		
		it "returns nils if id list is empty" do
			votelist = [vote(5,6), vote(5,7), vote(6,7)]
			id_list = []
			left, right = ChoiceGenerator.choice(votelist, id_list)
			expect(left).to be_nil
			expect(right).to be_nil
		end
		
		it "is successful if votelist nil" do
			votelist = nil
			id_list = [5,6,7]
			left, right = ChoiceGenerator.choice(votelist, id_list)
			expect(left).to_not be_nil
			expect(right).to_not be_nil
		end
		
		it "is successful if votelist empty" do
			votelist = []
			id_list = [5,6,7]
			left, right = ChoiceGenerator.choice(votelist, id_list)
			expect(left).to_not be_nil
			expect(right).to_not be_nil
		end
		
		it "is successful even if votelist has votes not in all_pairs " do
			votelist = [vote(5,6), vote(5,7)]
			id_list = [1,2,6]
			left, right = ChoiceGenerator.choice(votelist, id_list)
			expect(left).to_not be_nil
			expect(right).to_not be_nil
		end
	end # choices
	
	def vote(left, right)
		Vote.new(left_item_id: left, right_item_id: right)
	end
	
	def choice_map_count(map)
		count = 0
		map.each do |left, rightmap|
			rightmap.each do |right|
				count += 1
			end
		end
		count
	end
	
	def vote_equal?(vote1, vote2)
		vote1.left_item_id == vote2.left_item_id && 
					vote1.right_item_id == vote2.right_item_id
	end
	
end # choice generator







