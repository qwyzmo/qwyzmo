require 'spec_helper'

describe Qwyz do

	before(:each) do
		@user = Factory(:user)
		@attr = {
			:name					 => "test qwyz",
			:description		=> "test description",
			:question			 => "test question",
		}
	end
	
	it "creates a new instance given valid attributes" do
		@user.qwyzs.create!(@attr)
	end
	
	describe "user associations" do
		before(:each) do
			@qwyz = @user.qwyzs.create(@attr)
		end
		
		it "has a user attribute" do
			@qwyz.should respond_to(:user)
		end
		
		it "has the correct user" do
			@qwyz.user_id.should == @user.id
			@qwyz.user.should == @user
		end
		
	end # user associations
	
	describe "validations" do
		
		it "requires a user id" do
			Qwyz.new(@attr).should_not be_valid
		end
		
		it "requires nonblank name and question" do
			@user.qwyzs.build(:name			 => "").should_not be_valid
			@user.qwyzs.build(:question => "").should_not be_valid
		end
		
		it "rejects long names and questions" do
			@user.qwyzs.build(:name	 => "a" * 101).should_not be_valid
			@user.qwyzs.build(:question => "a" * 201).should_not be_valid
		end
	end
end
