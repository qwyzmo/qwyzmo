require "spec_helper"

describe QwyzItemsController do
	before do
		@user = create_test_user("n0", "n0@e.c", "password", "password")
		@qwyz = create_test_qwyz(@user.id, "name", "question", "desc")
		@qwyz_item = create_test_qwyz_item(@qwyz.id, "qidesc")
	end

	render_views
	
	describe "auth failures" do
		
		describe "when not logged in" do
			it "denies access to some actions" do
				get :new
				expect(response).to redirect_to(signin_path)
				post :create
				expect(response).to redirect_to(signin_path)
				
				get :show, id: 1
				expect(response).to redirect_to(signin_path)
				
				get :edit, id: 1
				expect(response).to redirect_to(signin_path)
				patch :update, id: 1
				expect(response).to redirect_to(signin_path)
				
				delete :destroy, id: 1
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
	end # auth failures
	
	describe "authenticated actions" do
		before do
			test_sign_in(@user)
		end
		
		describe "#new" do
			it "sets title and renders new template" do
				get :new, qwyz_id: @qwyz.id
				expect(response).to render_template :new
				expect(response.body).to have_title "Add a new Qwyz Item"
			end
		end
		
		describe "#create" do
			it "saves on success and redirects to qwyz show" do
				count = QwyzItem.count
				post :create, { qwyz_id: @qwyz.id,
							qwyz_item: { description: "d", 
								image: fixture_file_upload('ruby.jpg') }}
				expect(response).to render_template 'qwyzs/show'
				expect(QwyzItem.count).to eq(count + 1)
			end
			
			it "renders :new on failure" do
				count = QwyzItem.count
				post :create, { qwyz_id: @qwyz.id,
							qwyz_item: { description: ""}}
				expect(response).to render_template :new
				expect(QwyzItem.count).to eq(count)
			end
		end
		
		describe "#show" do
			it "renders show with title with valid id" do
				get :show, id: @qwyz_item.id
				expect(response).to render_template :show
				expect(response.body).to have_title "View Qwyz Item"
			end
		end
		
		describe "#edit" do
			it "renders correct template and title" do
				get :edit, id: @qwyz_item.id
				expect(response).to render_template :edit
				expect(response.body).to have_title "Edit Qwyz Item"
			end
		end
		
		describe "#update" do
			it "updates item on success, and renders show qwyz" do
				count = QwyzItem.count
				put :update, { id: @qwyz_item.id, 
							qwyz_item: { description: "d-update",
							image: fixture_file_upload('ruby.jpg') }}
				expect(response).to render_template 'qwyzs/show'
				expect(QwyzItem.count).to eq(count)
				db_item = QwyzItem.find(@qwyz_item.id)
				expect(db_item.description).to eq 'd-update'
			end
			
			it "on failure renders edit" do
				count = QwyzItem.count
				put :update, { id: @qwyz_item.id, 
							qwyz_item: { description: "",
							image: fixture_file_upload('ruby.jpg') }}
				expect(response).to render_template :edit
				expect(QwyzItem.count).to eq(count)
				db_item = QwyzItem.find(@qwyz_item.id)
				expect(db_item.description).to eq @qwyz_item.description
			end
		end
		
		describe "#delete" do
			it "sets the status properly and renders correct template" do
				
			end
		end
		
	end # authenticated actions
end











