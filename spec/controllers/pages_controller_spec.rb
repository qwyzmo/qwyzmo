require 'spec_helper'

describe PagesController do
	render_views

	before(:each) do
		@base_title = "Qwyzmo | "
	end

	describe "GET 'home'" do
		it "should be successful" do
			get :home
			expect(response).to be_success
			expect(response).to render_template("home")
		end
	end
end





