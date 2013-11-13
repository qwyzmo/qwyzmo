require 'spec_helper'

describe UsersController do
	render_views

	describe "get index" do
		describe "for non signed in users" do
			it "should deny access" do
				get :index
				response.should redirect_to(signin_path)
				flash[:notice].should =~ /sign in/i
			end
		end
		
		describe "for signed-in users" do
			before(:each) do
				@user 	= test_sign_in(Factory(:user))
				second 	= Factory(:user, name: "t1", email: "another@example.com")
				third 	= Factory(:user, name: "t2", email: "another@example.net")
				@users = [@user, second, third]
				30.times do
					@users << Factory(:user, name: Factory.next(:name), 
							email: Factory.next(:email))
				end
			end
			
			it "should be successful" do
				get :index
				response.should be_success
			end
			
			it "should have the right title" do
				get :index
				response.should have_selector("title", content: "All users")
			end
			
			it "should have an element for each user" do
				get :index
				@users[0..2].each do |user|
					response.should have_selector("li", content: user.name)
				end
			end
			
			it "should paginate users" do
				get :index
				response.should have_selector("div.pagination")
				response.should have_selector("span.disabled", content: "Previous")
				response.should have_selector("a", href: "/users?page=2", content: "2")
				response.should have_selector("a", href: "/users?page=2", content: "Next")
			end
		end # describe for signed in users
	end # describe get index

	describe "GET 'show'" do
		before(:each) do
			@user = Factory(:user)
		end

		it 'should be successful' do
			get :show, :id => @user
			response.should be_success
		end

		it 'should find the right user' do
			get :show, :id => @user
			assigns(:user).should == @user
		end

		it 'should have the right title' do
			get :show, :id => @user
			response.should have_selector("title", :content => @user.name)
		end

		it 'should include the users name' do
			get :show, :id => @user
			response.should have_selector('h1', :content => @user.name)
		end

		it 'should have a profile image' do
			get :show, :id => @user
			response.should have_selector("h1>img", :class => "gravatar")
		end
		
		it "should show the users microposts" do
			mp1 = Factory(:micropost, :user => @user, :content => "test2342 content")
			mp2 = Factory(:micropost, :user => @user, :content => "test9987 content")
			get :show, :id => @user
			response.should have_selector("span.content", :content => mp1.content)
			response.should have_selector("span.content", :content => mp2.content)
		end
	end # describe get show
	
	describe "GET 'new'" do
		it "should redirect to home if user signed in" do
			user = test_sign_in(Factory(:user))
			get :new
			response.should redirect_to(root_path)
		end
		
		it "should be successful" do
			get :new
			response.should be_success
		end
		
		it "should have the right title" do
			get :new
			response.should have_selector("title", :content => "Sign up")
		end
		
		it "should have a name field" do
			get :new
			response.should have_selector("input[name='user[name]'][type='text']")
		end
		
		it "should have an email field" do
			get :new
			response.should have_selector("input[name='user[email]'][type='text']")
		end
		
		it "should have a password field" do
			get :new
			response.should have_selector("input[name='user[password]'][type='password']")
		end
		
		it "should have a password confirmation field" do
			get :new
			response.should have_selector("input[name='user[password_confirmation]'][type='password']")
		end
	end # get new

	describe "POST 'create'" do
		describe "failure" do
			before(:each) do
				@attr = {:name => "", :email => "", :password => "", :password_confirmation => "" }
			end
			
			it "should not create a user" do
				lambda do
					post :create, :user => @attr
				end.should_not change(User, :count)
			end
			
			it "should have the right title" do
				post :create, :user => @attr
				response.should have_selector("title", :content => "Sign up")
			end
			
			it "should render the 'new' page" do
				post :create, :user => @attr
				response.should render_template('new')
			end
		end

		describe "success" do
			before(:each) do
				@attr = {:name => "New User", :email => "user@example.com", :password => "foobar", 
								:password_confirmation => "foobar" }
			end

			it "should redirect to root path if user signed in" do
				user = test_sign_in(Factory(:user))
				post :create, :user => @attr
				response.should redirect_to(root_path)
			end

			it "should create a user" do
				lambda do
					post :create, :user => @attr
				end.should change(User, :count).by(1)
			end

			it "should redirect to the user show page" do
				post :create, :user => @attr
				response.should redirect_to(user_path(assigns[:user]))
			end
			
			it "should have a welcome message" do
				post :create, :user => @attr
				flash[:success].should =~ /welcome to Qwyzmo/i
			end
			
			it "should sign the user in" do
				post :create, :user => @attr
				controller.should be_signed_in 
			end
		end # describe success
	end # describe post create

	describe "get edit" do

		before(:each) do
			@user = Factory(:user)
			test_sign_in(@user)
		end

		it "should be successful" do
			get :edit, :id => @user
			response.should be_success
		end

		it "should have the right title" do
			get :edit, :id => @user
			response.should have_selector("title", :content => "Edit user")
		end

		it "should have a link to change the gravatar" do
			get :edit, :id => @user
			gravatar_url = "http://gravatar.com/emails"
			response.should have_selector("a", :href => gravatar_url, :content => "change")
		end
	end # describe get edit

	describe "put update" do
		before(:each) do
			@user = Factory :user
			test_sign_in @user
		end
		
		describe "#update_status" do
			
			describe "as admin" do
				it "should change status and redirect to users page" do
					admin_user = @user
					target_user = Factory(:user, name: "test823", email: "test823@example.net")
					admin_user.admin = true
					put :update, id: target_user, 
						user: {status: User::STATUS[:deactivated].to_s}
					response.should redirect_to(users_path)
				end
			end
			
			describe "as non admin" do
				it "should not change status and redirect to users page, and flash error" do
					admin_user = @user
					target_user = Factory(:user, name: "test823", email: "test823@example.net")
					put :update, id: target_user, 
						user: {status: User::STATUS[:deactivated].to_s}
					response.should redirect_to(root_path)
				end
			end
		end
		
		describe "failure" do
			before(:each) do
				@attr = {email: "", name: "", password: "", password_confirmation: "" }
			end
			
			it "should render the 'edit' page" do
				put :update, id: @user, user: @attr
				response.should render_template('edit')
			end
			
			it "should have the right title" do
				put :update, id: @user, user: @attr
				response.should have_selector("title", content: "Edit user")
			end
		end # describe failure
		
		describe "success" do
			before(:each) do
				@attr = { :name => "New Name", :email => "user@example.org", :password => "barbaz",
									:password_confirmation => "barbaz"}
			end
			
			it "should change the users attributes" do
				put :update, :id => @user, :user => @attr
				@user.reload
				@user.name.should 	== @attr[:name]
				@user.email.should	== @attr[:email]
			end
			
			it "should redirect to the user show page" do
				put :update, :id => @user, :user => @attr
				response.should redirect_to(user_path(@user))
			end
			
			it "should have a flash message" do
				put :update, :id => @user, :user => @attr
				flash[:success].should =~ /updated/
			end
		end # describe success
	end # describe put update
	
	describe "authentication of edit/update pages" do
		before(:each) do
			@user = Factory(:user)
		end
		
		describe "for non-signed-in users" do
			before(:each) do
				wrong_user = Factory(:user, name: "foo234", email: "user@example.net")
				test_sign_in(wrong_user)
			end
			
			it "should deny access to 'edit'" do
				get :edit, id: @user
				response.should redirect_to(root_path)
			end
			
			it "should deny access to 'update'" do
				put :update, id: @user, :user => {}
				response.should redirect_to(root_path)
			end
		end
	end # describe authentication of edit/update pages
end # describe user controller










