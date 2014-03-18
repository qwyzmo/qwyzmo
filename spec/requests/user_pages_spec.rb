require 'spec_helper'

describe "User pages" do

	subject { page }
	
	describe "signup" do
		before { visit signup_path }

		let(:submit) { "Sign up" }

		it { should have_content('Sign up') }
		it { should have_title(title) }

		describe "with invalid information" do
			it "should not create a user" do
				expect { click_button submit }.not_to change(User, 
						:count)
			end
		end

		describe "with valid information" do
			before do
				fill_in "Name",				 			with: "Example User"
				fill_in "Email",						with: "user@example.com"
				fill_in "Password",		 			with: "foobarxx"
				fill_in "Confirm password", with: "foobarxx"
			end

			it "should create a user" do
				expect { click_button submit }.to change(User, :count).by(1)
			end
			
			describe "after saving the user" do
				before { click_button submit }
				let(:user) { User.find_by(email: 'user@example.com') }

				it { should have_title("Check Email") }
			end
		end
	end # signup
	
	describe "sign in" do
		before do
			@user = create_test_user("n", "e@q.c", "p" * 8, "p" * 8)
			visit signin_path
		end

		describe "with valid info" do
			before do
				complete_sign_in_form(@user.email, "p" * 8)
			end
			it { should have_title "Home" }
		end
		
		describe "with invalid info" do
			before do
				complete_sign_in_form(@user.email, "wrong password")
			end
			it { should have_title "Sign in" }
			it { should have_content "Invalid email/password combination" }
		end
	end

	describe "sign out" do
		before do
			@user = create_test_user("n", "e@q.c", "p" * 8, "p" * 8)
			sign_in(@user)
			visit signout_path
		end
		it { should have_title "Home" }
		it { should have_content "Select a Qwyz to begin" }
	end
end


