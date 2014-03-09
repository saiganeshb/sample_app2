include ApplicationHelper
def fill_in_signin_form(user) 
    fill_in "Email", with: user.email.upcase
    fill_in "Password", with: user.password
    click_button "Sign in"
end
def sign_in(user, options={})
    if options[:no_capybara]
        remember_token = User.new_remember_token
        cookies[:remember_token] = remember_token
         user.update_attribute(:remember_token, User.hash(remember_token))
    else
        visit signin_path
        fill_in_signin_form(user)
        
    end
end

