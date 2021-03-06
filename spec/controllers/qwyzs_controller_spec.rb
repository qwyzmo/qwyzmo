require "spec_helper" 

describe QwyzsController do
	render_views
	
	describe "authentication/authorization failures" do
		describe "when not logged in" do
			it "denies access to all actions" do
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
				@user = create_test_user("n0", "n0@e.c", "password", "password")
				@qwyz = create_test_qwyz(@user.id, "name", "question", "desc")
				@wrong_user = create_test_user("n", "e@n.c", "password", "password")
				test_sign_in(@wrong_user)
			end
			
			it "denies access to edit, update, destroy" do
				post :edit, id: @qwyz.id
				expect(response).to redirect_to qwyzs_url
				delete :destroy, id: @qwyz.id
				expect(response).to redirect_to qwyzs_url
				post :update, id: @qwyz.id
				expect(response).to redirect_to qwyzs_url
				get :show, id: @qwyz.id
				expect(response).to redirect_to qwyzs_url
			end
		end # logged in as wrong user
	end # authentication/authorization failures
	
	describe "authenticated actions" do
		before do
			@user = create_test_user("n0", "n0@e.c", "password", "password")
			@qwyz = create_test_qwyz(@user.id, "name", "question", "desc")
			test_sign_in(@user)
		end
		
		describe "#new" do
			it "sets title correctly and renders new template" do
				get :new
				expect(response).to render_template :new
				expect(response.body).to have_title "Create a New Qwyz"
			end
		end
		
		describe "#create" do
			it "saves on success and redirects to index" do
				count = Qwyz.count
				qname = "test name"
				qquest = "test question"
				qdescr = "test description"
				post :create, { qwyz: {
															name: 				qname,
															question: 		qquest,
															description: 	qdescr,
											}}
				expect(response).to render_template :index
				expect(response.body).to have_title "My Qwyzs"
				expect(Qwyz.count).to eq(count + 1)
				db_qwyz = Qwyz.find_by(name: qname)
				expect(db_qwyz.user_id).to 			eq @user.id
				expect(db_qwyz.question).to 		eq qquest
				expect(db_qwyz.description).to 	eq qdescr
			end
			
			it "renders :new on failure" do
				count = Qwyz.count
				post :create, { qwyz: {
															name: 				"",
															question: 		"test question",
															description: 	"test description",
											}}
				expect(response).to render_template :new
				expect(Qwyz.count).to eq count 
			end
		end # create
		
		describe "#edit" do
			it "renders :edit for good id" do
				get :edit, id: @qwyz.id
				expect(response).to render_template :edit
				expect(response.body).to have_title "Edit Qwyz"
			end
		end
		
		describe "#update" do
			it "on success gives message, renders :index, and updates record" do
				count = Qwyz.count
				qname = "test name"
				qquest = "test question"
				qdescr = "test description"
				post :update, { id: @qwyz.id, qwyz: {
															name: 				qname,
															question: 		qquest,
															description: 	qdescr,
											}}
				expect(response).to render_template :index
				expect(response.body).to have_content "Qwyz updated."
				expect(Qwyz.count).to eq count
				db_qwyz = Qwyz.find(@qwyz.id)
				expect(db_qwyz.name).to 				eq qname
				expect(db_qwyz.question).to 		eq qquest
				expect(db_qwyz.description).to 	eq qdescr
			end
			
			it "on failure, gives err msg, renders :edit, and db unchanged" do
				count = Qwyz.count
				qname = ""
				qquest = "test question"
				qdescr = "test description"
				post :update, { id: @qwyz.id, qwyz: {
															name: 				qname,
															question: 		qquest,
															description: 	qdescr,
											}}
				expect(response).to render_template :edit
				expect(response.body).to_not have_content "Qwyz updated."
				expect(Qwyz.count).to eq count
				db_qwyz = Qwyz.find(@qwyz.id)
				expect(db_qwyz.name).to_not					eq qname
				expect(db_qwyz.question).to_not 		eq qquest
				expect(db_qwyz.description).to_not 	eq qdescr
			end
		end
		
		describe "#index" do
			it "renders index template and has correct title" do
				get :index
				expect(response).to render_template :index
				expect(response.body).to have_title "My Qwyzs"
			end
		end

		describe "#show_inactive_qwyz_items" do
			it "renders correct template and title" do
				get :show_inactive_qwyz_items, { id: @qwyz.id }
				expect(response).to render_template :show_inactive_qwyz_items
				expect(response.body).to have_title "Inactive Qwyz Items"
			end
		end

		describe "#destroy" do
			# TODO implement destroy tests when destroy is implemented fully
		end
	end # authenticated actions
end
# 	
# 
# 
# 
# 
