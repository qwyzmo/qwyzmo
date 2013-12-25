
require 'spec_helper'

describe "Authentication" do

	subject { page }

	describe "signin page" do
		before { visit signin_path }

		it { should have_content('Sign in') }
		it { should have_title('Sign in') }
	end
	
	describe "signin" do
		before { visit signin_path }

		describe "with invalid information" do
			before { click_button "Sign in" }
			
			it { should have_title('Sign in') }
			it { should have_selector('div.error', 
				text: 'Invalid') }
				
			describe "after visiting another page" do
				before { click_link "Home" }
				it { should_not have_selector('div.error') }
			end
		end
		
		describe "with valid information" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				fill_in "Email",		with: user.email.upcase
				fill_in "Password", with: user.password
				click_button "Sign in"
			end

			it { should have_title(user.name) }
			# it { should have_link('My Account', href: user_path(user)) }
			it { should have_link('Sign out',		href: signout_path) }
			it { should_not have_link('Sign in', href: signin_path) }
			it { should have_link('Edit Account',		href: edit_user_path(user)) }

			describe "followed by signout" do
				before { click_link "Sign out" }
				it { should have_link('Sign in') }
			end
		end
	end # signin
	
	describe "edit" do
		let(:user) { FactoryGirl.create(:user) }
		before do 
			sign_in(user)
			visit edit_user_path(user)
		end

		describe "page" do
			it { should have_content("Edit Account Info") }
			it { should have_title("Edit Account") }
		end

		describe "with valid information" do
			let(:new_name)	{ "New Name".downcase }
			let(:new_email) { "new@example.com" }
			before do
				fill_in "Name",						 with: new_name
				fill_in "Email",						with: new_email
				fill_in "Password",		with: user.password
				# fill_in "Confirm Password", with: user.password
				click_button "Save changes"
			end

			it { should have_title(new_name) }
			it { should have_selector('div.success') }
			it { should have_link('Sign out', href: signout_path) }
			specify { expect(user.reload.name).to	eq new_name }
			specify { expect(user.reload.email).to eq new_email }
		end
	end # edit
	
end





