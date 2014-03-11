require 'spec_helper'

describe "LayoutLinks" do
	
	subject { page }
	
	describe "should have a Home page at '/'" do
		before { visit '/'}
		it { should have_title("Home")}
		# it { should have_link("Sign up now!")}
		it { should have_link("Sign in")}
	end
end

