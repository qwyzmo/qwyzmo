require "spec_helper"

describe QwyzsController do
	render_views
	
	describe "access control" do
		it "denies access to create" do
			post :create
			response.should redirect_to(signin_path)
		end
		
	end
end