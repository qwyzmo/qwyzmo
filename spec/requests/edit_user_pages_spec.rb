
require 'spec_helper'

describe "edit pages" do

	subject { page }

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

	describe "edit password" do
		let(:user) { FactoryGirl.create(:user) }
		before do 
			sign_in(user)
			visit editpass_path(user)
		end

		describe "page" do
			it { should have_content("Change Password")}
			it { should have_title("Change Password")}
		end

		describe "with valid information" do
			before do
				fill_in "Current password",				with: user.password
				fill_in "New password",						with: "newpassword"
				fill_in "Confirm new password",		with: "newpassword"
				click_button "Change Password"
			end

			it { should have_title(user.name) }
			it { should have_selector('div.success') }
		end
		
		describe "with wrong password" do
			before do
				fill_in "Current password",				with: "wrongpass"
				fill_in "New password",						with: "newpassword"
				fill_in "Confirm new password",		with: "newpassword"
				click_button "Change Password"
			end

			it { should have_title("Change Password") }
			it { should have_css('div#error_explanation') }
		end
		
		describe "with new password too short" do
			before do
				fill_in "Current password",				with: user.password
				fill_in "New password",						with: "short"
				fill_in "Confirm new password",		with: "short"
				click_button "Change Password"
			end

			it { should have_title("Change Password") }
			it { should have_css('div#error_explanation') }
		end
		
		describe "with new password confirm mismatch" do
			before do
				fill_in "Current password",				with: user.password
				fill_in "New password",						with: "newpassword"
				fill_in "Confirm new password",		with: "mismatched"
				click_button "Change Password"
			end

			it { should have_title("Change Password") }
			it { should have_css('div#error_explanation') }
		end
	end
end