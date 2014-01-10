
require 'spec_helper'

describe 'password reset pages' do
	
	subject { page }
	
	describe "send password reset code page" do
		before { visit forgotpass_path }
		pending
		
		it { should have_title "Reset password" }
		describe "" do
			before do
				fill_in "Email"
				click_button "Send reset code"
			end
			pending
		end
	end
	
	describe "password reset sent page" do
		before { visit passresetsent_path }
		
		it { should have_title "Reset code sent" }
		it { should have_content "Password reset code has been sent" }
		it { should have_content "Please check your email" }
		pending
	end
	
	describe "reset password page" do
		
		pending
	end
	
end
