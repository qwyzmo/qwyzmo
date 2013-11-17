require 'spec_helper'

describe "friendly forwardings" do
	it "should forward to the requested page after signin" do
		user = Factory(:user)
		visit edit_user_path(user)
		# the test automatically follows the redirect to the signin page.
		fill_in :email,				:with => user.email
		fill_in :password,		:with => user.password
		click_button
		# the test follows the redirect again, this time to users/edit.
#		response.should render_template('edit')
		sleep 3
		response.should have_selector("title", :content => "Edit Account Info")
#		expect(page).to have_title('Edit user')
	end
end


