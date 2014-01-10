
require 'spec_helper'

describe "authorization" do
	subject { page }

	describe "for non-signed-in users" do
		let(:user) { FactoryGirl.create(:user) }

		describe "when attempting to visit a protected page" do
			before do
				visit edit_user_path(user)
				fill_in "Email",		with: user.email
				fill_in "Password", with: user.password
				click_button "Sign in"
			end

			describe "after signing in" do

				it "should render the desired protected page" do
					expect(page).to have_title('Edit Account')
				end
			end
		end

		describe "in the Users controller" do

			describe "visiting the edit page" do
				before { visit edit_user_path(user) }
				it { should have_title('Sign in') }
			end

			describe "submitting to the update action" do
				before { patch user_path(user) }
				specify { expect(response).to redirect_to(signin_path) }
			end
		end
	end # for non signed in users

	describe "as wrong user" do
		let(:user) { FactoryGirl.create(:user) }
		let(:wrong_user) { FactoryGirl.create(:user, 
			email: "wrong@example.com", name: "wrong name") }
		before { sign_in user, no_capybara: true }

		describe "submitting a GET request to the Users#edit action" do
			before { get edit_user_path(wrong_user) }
			specify { expect(response.body).not_to match('Edit Account') }
			specify { expect(response).to redirect_to(root_url) }
		end

		describe "submitting a PATCH request to the Users#update action" do
			before { patch user_path(wrong_user) }
			specify { expect(response).to redirect_to(root_url) }
		end
	end # as wrong user
end # authorization








