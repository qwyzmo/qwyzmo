require 'spec_helper'

describe PagesController do
	render_views

	before(:each) do
		@base_title = "Qwyzmo | "
	end

	# TODO

	# describe "GET 'home'" do
		# it "should be successful" do
			# get 'home'
			# response.should be_success
		# end
# 		
		# it "should have the right title" do
			# get 'home'
			# response.should have_selector("title", :content => @base_title + "Home")
		# end
# 		
		# it "should have sign up if user not signed in" do
			# get 'home'
			# response.should have_selector("a", :href => "/signup")
		# end
# 		
		# it "should NOT have sign up if user IS signed in" do
			# user = test_sign_in(Factory(:user))
			# get 'home'
			# response.should_not have_selector("a", :href => "/signup")
		# end
	# end
# 
	# describe "GET 'contact'" do
		# it "should be successful" do
			# get 'contact'
			# response.should be_success
		# end
		# it "should have the right title" do
			# get 'contact'
			# response.should have_selector("title", :content => @base_title + "Contact")
		# end
	# end
# 
	# describe "GET 'about'" do
		# it "should be successful" do
			# get 'about'
			# response.should be_success
		# end
		# it "should have the right title" do
			# get 'about'
			# response.should have_selector("title", :content => @base_title + "About")
		# end
	# end
# 
	# describe "GET 'help'" do
		# it "should be successful" do
			# get 'help'
			# response.should be_success
		# end
# 
		# it "should have the right title" do
			# get 'help'
			# response.should have_selector("title", :content => @base_title + "Help")
		# end
	# end

end

