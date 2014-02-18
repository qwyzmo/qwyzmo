require "spec_helper"

describe "qwyz item pages" do
	subject { page }
	
	before do
		@user = create_test_user("n", "e@q.c", "passpass", "passpass")
		@qwyz = create_test_qwyz(@user.id, "name", "question", "desc")
		sign_in(@user)
	end
	
	describe "create a new qwyz item" do
		before do
			visit new_qwyz_item_path(qwyz_id: @qwyz.id)
		end
		
		it { should have_content "Add a New Item to"}
		it { should have_title   "Add a new Qwyz Item"}
		
		describe "with valid info" do
			before { fill_form("valid description", 
						'/spec/fixtures/ruby.jpg', "save") }
			
			it { should have_title "View Qwyz" }
			it { should have_content "Active qwyz items" }
		end
		
		describe "with invalid info" do
			before { fill_form("", '/spec/fixtures/ruby.jpg', "save") }
			
			it { should have_title "Add a new Qwyz item" }
			it { should have_content "Add a New Item to" }
		end
	end
	
	describe "edit qwyz item" do
		before do
			@qwyz_item = create_test_qwyz_item(@qwyz.id, "desc")
			visit edit_qwyz_item_path(@qwyz_item.id)
		end

		describe "with valid info" do
			before { fill_form("desc", '/spec/fixtures/ruby.jpg', 'update') }
			
			it { should have_title "View Qwyz" }
			it { should have_content "Active qwyz items" }
		end

		describe "with invalid info" do
			before { fill_form("", '/spec/fixtures/ruby.jpg', "update") }
			
			it { should have_title "Edit Qwyz Item" }
			it { should have_content "Edit Qwyz Item" }
		end
	end
	
	def fill_form(description, image, button_name)
		fill_in "qwyz_item_description", 	with: description
		attach_file('qwyz_item_image', File.join(Rails.root, image))
		click_button button_name
	end
	
end

# TODO: implement