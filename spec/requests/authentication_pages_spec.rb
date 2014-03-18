
require 'spec_helper'

describe "authorization" do
	before do
		@user = create_test_user("FactGirl Username", "fg@q.com", 
				"asdfasdf", "asdfasdf")
	end
	subject { page }

	describe "for non-signed-in users" do

		describe "when attempting to visit a protected page" do
			before do
				visit edit_user_path(@user)
				complete_sign_in_form(@user.email, @user.password)
			end

			describe "after signing in" do

				it "should render the desired protected page" do
					expect(page).to have_title('Edit Account')
				end
			end
		end

		describe "in the Users controller" do

			describe "visiting the edit page" do
				before { visit edit_user_path(@user) }
				it { should have_title('Sign in') }
			end

			describe "submitting to the update action" do
				before { patch user_path(@user) }
				specify { expect(response).to redirect_to(signin_path) }
			end
		end
	end # for non signed in users

	describe "as wrong user" do
		before do
			@wrong_user = create_test_user("wrong name", "wrong@example.com", 
						"asdfasdf", "asdfasdf")
			sign_in @user, no_capybara: true
		end

		describe "submitting a GET request to the Users#edit action" do
			before { get edit_user_path(@wrong_user) }
			specify { expect(response.body).not_to match('Edit Account') }
			specify { expect(response).to redirect_to(root_url) }
		end

		describe "submitting a PATCH request to the Users#update action" do
			before { patch user_path(@wrong_user) }
			specify { expect(response).to redirect_to(root_url) }
		end
	end # as wrong user
end # authorization








