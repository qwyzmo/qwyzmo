
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
				
			it { should have_title 'Get reset password link'}
		end
	end
	
	describe "signin" do
		before do
			@user = create_test_user("FactGirl Username", "fg@q.com", 
					"asdfasdf", "asdfasdf")
		end
		before { visit signin_path }

		describe "with invalid information (blank)" do
			before { complete_sign_in_form("","") }

			it { should have_title('Sign in') }
			it { should have_selector('div.error', 
				text: 'Invalid') }
			describe "after visiting another page" do
				before { click_link "Home" }
				it { should_not have_selector('div.error') }
			end
		end

		describe "with valid information for activated user" do
			before do
				complete_sign_in_form(@user.email, @user.password)
			end

			it { should have_title("Home") }
			it { should have_link('Sign out',		href: signout_path) }
			it { should_not have_link('Sign in', href: signin_path) }
			it { should have_link('Edit account',		href: edit_user_path(@user)) }

			describe "followed by signout" do
				before { click_link "Sign out" }
				it { should have_link('or Sign up', href: signup_path) }
			end
		end # valid active @user
		
		describe "with valid information for pending_email @user" do
			before do
				@user.status = User::STATUS[:pending_email]
				@user.save!
				fill_in "Email",		with: @user.email
				fill_in "Password", with: @user.password
				complete_sign_in_form(@user.email, @user.password)
			end

			it { should 		have_title("Check Email") }
			it { should have_content("check your email") }
			it { should_not have_link('Sign out',		href: signout_path) }
			it { should 		have_link('or Sign up', href: signup_path) }
			it { should 		have_link('Home',				href: root_path) }
		end

		describe "with valid information for deactivated @user" do
			before do
				@user.status = User::STATUS[:deactivated]
				@user.save!
				complete_sign_in_form(@user.email, @user.password)
			end

			it { should 		have_title("Sign in") }
			it { should have_content("deactivated") }
			it { should_not have_link('Sign out',		href: signout_path) }
			it { should 		have_link('or Sign up', 		href: signup_path) }
			it { should 		have_link('Home',				href: root_path) }
		end
	end # signin
end