require 'spec_helper'

describe "qwyz pages" do
	subject { page }

	before do
		@user = create_test_user("n", "e@q.c", "passpass", "passpass")
		sign_in(@user)
	end

	describe "create a qwyz" do
		before { visit new_qwyz_path }
		it { should have_content("Create a Qwyz")}
		it { should have_title("Create a New Qwyz")}
		
		describe "with valid info" do
			before { fill_form("valid name", "Create Qwyz")}
			it { should have_title("My Qwyzs") }
			it { should have_content("Qwyz created.")}
		end
		
		describe "with invalid info" do
			before { fill_form("", "Create Qwyz")}
			it { should have_title("Create a New Qwyz")}
			it { should have_content("Name can't be blank")}
		end
	end # create a qwyz

	describe "edit qwyz" do
		before do
			@qwyz = create_test_qwyz(@user.id, "n", "q", "d")
			visit edit_qwyz_path(@qwyz)
		end
			
		it { should have_content("Edit Qwyz")}
		it { should have_title("Edit Qwyz")}
		
		describe "with valid info" do
			before { fill_form("valid name", "Update")}
			it { should have_title("My Qwyzs") }
			it { should have_content("Qwyz updated")}
		end
		
		describe "with invalid info" do
			before { fill_form("", "Update")}
			it { should have_title("Edit Qwyz")}
			it { should have_content("Name can't be blank")}
		end
	end # edit qwyz

	def fill_form(name, button_name)
		fill_in "qwyz_name", 				with: name
		fill_in "qwyz_question", 		with: "qwyz question"
		fill_in "qwyz_description",	with: "qwyz description" 
		click_button button_name
	end
end # qwyz pages




