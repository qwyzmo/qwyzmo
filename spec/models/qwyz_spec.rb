require 'spec_helper'

describe Qwyz do
	before do
		@user = create_test_user("n", "e@q.com", "passpass", "passpass")
	end
	
	describe "validations" do
		before do
			@qcount = Qwyz.count
		end
		
		it "fails to save if user_id nil" do
			qwyz = newqwyz(nil, "n", "q", "d")
			check_save_failed qwyz
		end

		it "fails to save if name empty" do
			qwyz = newqwyz(@user.id, "", "q", "d")
			check_save_failed qwyz
		end
		
		it "fails to save if question empty" do
			qwyz = newqwyz(@user.id, "n", "", "d")
			check_save_failed qwyz
		end
		
		it "fails to save if user_id invalid" do
			qwyz = newqwyz(9999, "n", "q", "d")
			check_save_failed qwyz
		end
		
		it "saves with valid fields" do
			qwyz = newqwyz(@user.id, "n", "q", "d")
			save_result = qwyz.save
			expect(save_result).to be_true
			expect(Qwyz.count).to eq @qcount + 1
		end
	end
	
	describe "counting active and inactive items" do
		before do
			@qwyz = create_test_qwyz(@user.id, "n", "q", "d")
			qitem1 = newitem(@qwyz.id, QwyzItem::STATUS[:active])
			qitem2 = newitem(@qwyz.id, QwyzItem::STATUS[:active])
			qitem3 = newitem(@qwyz.id, QwyzItem::STATUS[:active])
			qitem4 = newitem(@qwyz.id, QwyzItem::STATUS[:inactive])
			qitem5 = newitem(@qwyz.id, QwyzItem::STATUS[:inactive])
		end
		
		it "returns correct number of active items" do
			expect(@qwyz.active_item_count).to eq 3
		end

		it "returns correct number of inactive items" do
			expect(@qwyz.inactive_item_count).to eq 2
		end
	end
	
	describe "#unvoted_item_pair" do
		before do
			# create a list of votes.
			
		end
		
		it "returns two items from the list" do
			
		end
		
		it "returns nil if less than two unvoted items in list" do
			
		end
	end
	
	def check_save_failed(qwyz)
		save_result = qwyz.save
		expect(save_result).to be_false
		expect(Qwyz.count).to eq @qcount
	end
	
	def newqwyz(user_id, name, question, description)
		Qwyz.new(user_id: user_id, name: name, 
				question: question, description: description)
	end
	
	def newitem(qwyz_id, stat)
		create_test_qwyz_item(qwyz_id, "d", "/spec/fixtures/ruby.jpg", stat)
	end
end


