include ApplicationHelper

def sign_in(user, options={})
  if options[:no_capybara]
    # Sign in when not using Capybara as well.
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
  else
    visit root_path
    within(:css, "div#login-bar") do
	    fill_in "header-email-field",    with: user.email
	    fill_in "header-password-field", with: user.password
	    click_button "Sign in"
    end
  end
end
