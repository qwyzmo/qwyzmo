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
	
	def check_save_failed(qwyz)
		save_result = qwyz.save
		expect(save_result).to be_false
		expect(Qwyz.count).to eq @qcount
	end
	
	def newqwyz(user_id, name, question, description)
		Qwyz.new(user_id: user_id, name: name, 
				question: question, description: description)
	end
end


