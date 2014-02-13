require "spec_helper"

describe QwyzItemsController do
	render_views
	
	describe "auth failures" do
		before do
			@user = create_test_user("n0", "n0@e.c", "password", "password")
			@qwyz = create_test_qwyz(@user.id, "name", "question", "desc")
		end
		
		describe "when not logged in" do
			it "denies access to some actions" do
				post :create
				expect(response).to redirect_to(signin_path)
				get :new
				expect(response).to redirect_to(signin_path)
				get :index
				expect(response).to redirect_to(signin_path)
				delete :destroy, id: 1
				expect(response).to redirect_to(signin_path)
				patch :update, id: 1
				expect(response).to redirect_to(signin_path)
				get :edit, id: 1
				expect(response).to redirect_to(signin_path)
				get :show, id: 1
				expect(response).to redirect_to(signin_path)
			end
		end
		
		describe "logged in as wrong user" do
			before do
				@qwyz_item = create_test_qwyz_item(@qwyz.id, 'item desc')
				@wrong_user = create_test_user("n", "e@n.c", "password", "password")
				test_sign_in(@wrong_user)
			end
			
			it "denies access to edit, update, destroy" do
				post :edit, id: @qwyz_item.id
				expect(response).to redirect_to users_url
				delete :destroy, id: @qwyz_item.id
				expect(response).to redirect_to users_url
				post :update, id: @qwyz_item.id
				expect(response).to redirect_to users_url
			end
		end
		
		describe "with wrong qwyz" do
			pending
		end
	end # auth failures
	
	describe "authenticated actions" do
		pending
	end
end


