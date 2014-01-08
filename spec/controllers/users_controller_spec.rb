require 'spec_helper'

describe UsersController do
	let(:pending_user) do
		User.new(	{	email: 'pend@q.c', 
								name: 'pending user', 
								password: "asdfasdf", 
								password_confirmation: "asdfasdf",
								status: User::STATUS[:pending_email]})
	end

	before do
		pending_user.save!
	end

	it "is successful for valid user" do
		get :activate, atok: pending_user.activation_token
		expect(response).to render_template("users/activated")

		saved_user = User.find(pending_user.id)
		expect(saved_user.activated?).to be_true 
	end

	it "fails for wrong activation token" do
		get :activate, atok: "xxxxxxx"
		expect(response).to render_template("users/activation_failed")

		saved_user = User.find(pending_user.id)
		expect(saved_user.pending_email?).to be_true 
	end
end
