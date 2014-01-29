require 'spec_helper'

describe "User pages" do

	subject { page }

	describe "signup page" do
		before { visit signup_path }

		it { should have_content('Sign up') }
		it { should have_title(title) }
	end
	
	describe "signup" do

		before { visit signup_path }

		let(:submit) { "Sign up" }

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
end


# describe "Users" do
	# describe "signup" do
		# describe "failure" do
			# it "should not make a new user" do
				# lambda do
					# visit signup_path
					# fill_in "Name",				 :with => ""
					# fill_in "Email",				:with => ""
					# fill_in "Password",		 :with => ""
					# fill_in "Confirmation", :with => ""
					# click_button
					# response.should render_template('users/new')
					# response.should have_selector("div#error_explanation")
				# end.should_not change(User, :count)
			# end
		# end # failure
		# describe "success" do
			# it "should make a new user" do
				# lambda do
					# visit signup_path
					# fill_in "Name",				 :with => "Test User"
					# fill_in "Email",				:with => "testuser@example.com"
					# fill_in "Password",		 :with => "testpassword"
					# fill_in "Confirmation", :with => "testpassword"
					# click_button
					# response.should have_selector("div.flash.success", :content => "Welcome")
					# response.should render_template('users/show')
				# end.should change(User, :count).by(1)
			# end
		# end
	# end # signup 
	# describe "sign in/out" do
		# describe "failure" do
			# it "should not sign a user in" do
				# integration_sign_in(User.new) 
				# response.should have_selector("div.flash.error", :content => "Invalid")
			# end
		# end
		# describe "success" do
			# it "should sign a user in and out" do
				# user = Factory(:user)
				# user.encrypt_save
				# visit signin_path
				# fill_in :email,		 :with => user.email
				# fill_in :password,	:with => user.password
				# click_button
				# controller.should be_signed_in
				# click_link "Sign out"
				# controller.should_not be_signed_in
			# end
		# end #describe success
	# end # describe sign in/out
# end	# users
