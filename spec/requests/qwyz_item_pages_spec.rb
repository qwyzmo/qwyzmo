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
		
		it { should have_content "Add a New Image"}
		it { should have_title   "Add a new Qwyz Item"}
		
		describe "with valid info" do
			before { fill_form("valid description", 
						'/spec/fixtures/ruby.jpg', "save") }
			
			it { should have_title "View Qwyz" }
			it { should have_content "Manage Qwyz Images" }
		end
		
		describe "with invalid info" do
			before { fill_form("", '/spec/fixtures/ruby.jpg', "save") }
			
			it { should have_title "Add a new Qwyz item" }
			it { should have_content "Add a New Image" }
		end
	end
	
	describe "edit qwyz item" do
		before do
			@qwyz_item = create_test_qwyz_item(@qwyz.id, "desc")
			visit edit_qwyz_item_path(@qwyz_item.id)
		end

		describe "with valid info" do
			before { fill_form("desc", nil, 'update') }
			
			it { should have_title "View Qwyz" }
			it { should have_content "Manage Qwyz Images" }
		end

		describe "with invalid info" do
			before { fill_form("", nil, "update") }
			
			it { should have_title "Edit Qwyz Item" }
			it { should have_content "Edit Qwyz Item" }
		end
	end
	
	describe "deactivate and activate qwyz item" do
		before do
			@qwyz_item = create_test_qwyz_item(@qwyz.id, "desc")
			visit qwyz_path(@qwyz.id)
		end
		
		it { should have_content "(0 images inactive)" }
		
		describe "upon deactivation" do
			before { click_button "Deactivate" }
			
			it { should have_title "View Qwyz" }
			it { should have_content "(1 image inactive)" }
			
			describe "visit to de-activated qwyz items page" do
				before { click_link "Manage inactive images >" }
				
				it { should have_title "Inactive Qwyz Items" }
				it { should have_content "(0 images active)" }
				
				describe "upon activation" do
					before { click_button "Activate" }
					
					it { should have_title "Inactive Qwyz Items" }
					it { should have_content "(1 image active)"}
				end
			end
		end
	end
	
	describe "show qwyz item" do
		before do
			@qwyz_item1 = create_test_qwyz_item(@qwyz.id, "desc1")
			@qwyz_item2 = create_test_qwyz_item(@qwyz.id, "desc2")
			@qwyz_item3 = create_test_qwyz_item(@qwyz.id, "desc3")
			visit qwyz_item_path(@qwyz_item2)
		end
		
		it { should have_title "View Qwyz Item" }
		it { should have_css "a#previous-image" }
		it { should have_css "a#next-image" }
	end
	
	def fill_form(description, image, button_name)
		fill_in "qwyz_item_description", 	with: description
		attach_file('qwyz_item_image', File.join(Rails.root, image)) unless image.nil?
		click_button button_name
	end
	
end







