require "spec_helper"

describe QwyzsController do
	render_views
	
	describe "access control" do
		it "denies access to create" do
			post :create
			response.should redirect_to(signin_path)
		end
		
		it "denies access to add" do
			get :add
			response.should redirect_to(signin_path)
			flash[:notice].should =~ /sign in/i
		end
		
		it "denies access to index" do
			get :index
			response.should redirect_to(signin_path)
			flash[:notice].should =~ /sign in/i
		end
		
		it "denies access to destroy" do
			delete :destroy, :id => 1
			response.should redirect_to(signin_path)
		end
	end
	
	describe "create" do
		before(:each) do
			@user = test_sign_in(Factory(:user))
		end
		
		describe "failure" do
			before(:each) do
				@attr = { :name => " ", :question => " "}
			end
			
			it "doesnt create a qwyz if name is empty" do
				lambda do
					post :create, :qwyz => { :name => " " }
				end
			end
			
			it "doesnt create a qwyz if question is empty" do
				lambda do
					post :create, :qwyz => { :question => " " }
				end
			end
			
			it "returns to the add qwyz page" do
				post :create, :qwyz => { :name => " " }
				response.should render_template('qwyzs/add')
			end
			
		end # failure
		
		describe "success" do
			before(:each) do
				@fields = { :name => "test name", :question => "test question"}
			end
			
			it "creates a qwyz" do
				lambda do
					post :create, :qwyz => @fields
				end.should change(Qwyz, :count).by(1)
			end
			
			it "redirects to the qwyz page" do
				post :create, :qwyz => @fields
				response.should redirect_to(qwyzs_path)
			end
		end # success
	end
	
	describe "add" do
		
		it "redirects to add page if signed in" do
			@user = test_sign_in(Factory(:user))
			get :add
			response.should render_template('qwyzs/add')
		end
		
		it "redirects to sign in page if not signed in" do
			get :add
			response.should redirect_to(signin_path)
		end
		
	end
	
	describe "index" do
		it "redirects to qwyz index page" do
			@user = test_sign_in(Factory(:user))
			get :index
			response.should render_template('qwyzs/index')
		end
		
	end
	
	describe "destroy" do
		describe "for incorrect user" do
			before(:each) do
				@user = Factory(:user)
				wrong_user = Factory(:user, :email => Factory.next(:email))
				test_sign_in(wrong_user)
				@qwyz = Factory(:qwyz, :user => @user)
			end
			
			it "should deny access, and redirect to qwyzs page" do
				delete :destroy, :id => @qwyz
				response.should redirect_to(qwyzs_path)
			end
		end
		
		describe "for correct user" do
			before(:each) do
				@user = test_sign_in(Factory(:user))
				@qwyz = Factory(:qwyz, :user => @user)
			end
			
			it "should delete a qwyz, and redirect to qwyzs page" do
				lambda do
					delete :destroy, :id => @qwyz
				end.should change(Qwyz, :count).by(-1)
				response.should redirect_to(qwyzs_path)
			end
		end
	end
end


