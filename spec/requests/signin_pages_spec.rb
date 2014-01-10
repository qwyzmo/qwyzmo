
require 'spec_helper'

describe "signin pages" do

	subject { page }

	describe "signin page" do
		before { visit signin_path }

		it { should have_content('Sign in') }
		it { should have_title('Sign in') }
		it { should have_link('Forgot password?')}
		
		describe "clicking forgot password link" do
			before { click_link "Forgot password?" }
				
			it { should have_title 'Reset password'}
		end
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

		describe "with valid information for activated user" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				fill_in "Email",		with: user.email
				fill_in "Password", with: user.password
				click_button "Sign in"
			end

			it { should have_title(user.name) }
			it { should have_link('Sign out',		href: signout_path) }
			it { should_not have_link('Sign in', href: signin_path) }
			it { should have_link('Edit Account',		href: edit_user_path(user)) }

			describe "followed by signout" do
				before { click_link "Sign out" }
				it { should have_link('Sign in') }
			end
		end # valid active user
		
		describe "with valid information for pending_email user" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				user.status = User::STATUS[:pending_email]
				user.save!
				fill_in "Email",		with: user.email
				fill_in "Password", with: user.password
				click_button "Sign in"
			end

			it { should 		have_title("Check Email") }
			it { should have_content("check your email") }
			it { should_not have_link('Sign out',		href: signout_path) }
			it { should 		have_link('Sign in', 		href: signin_path) }
			it { should 		have_link('Home',				href: root_path) }
		end

		describe "with valid information for deactivated user" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				user.status = User::STATUS[:deactivated]
				user.save!
				fill_in "Email",		with: user.email
				fill_in "Password", with: user.password
				click_button "Sign in"
			end

			it { should 		have_title("Sign in") }
			it { should have_content("deactivated") }
			it { should_not have_link('Sign out',		href: signout_path) }
			it { should 		have_link('Sign in', 		href: signin_path) }
			it { should 		have_link('Home',				href: root_path) }
		end
	end # signin
end