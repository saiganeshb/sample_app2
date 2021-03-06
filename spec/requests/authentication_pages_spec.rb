require 'spec_helper'

describe "Authentication" do

    subject { page }

    describe "Authorization" do
        describe "as non admin user" do
            let(:user) {FactoryGirl.create(:user)}
            let(:non_admin) {FactoryGirl.create(:user)}
            before {sign_in non_admin, no_capybara: true}
            describe "submitting delete request to users#destroy" do
                before {delete user_path(user)}
                specify {expect(response).to redirect_to(root_url)}
            end
        end
        describe "Friendly forwarding" do
            let(:user) {FactoryGirl.create(:user)}
            describe "ff to edit page" do
                before do
                    visit edit_user_path(user)
                    fill_in_signin_form(user)
                end
                it {should have_title('Edit user')}
            end
        end
        describe "As wrong user" do
            let(:user) {FactoryGirl.create(:user)}
            let(:wrong_user) {FactoryGirl.create(:user, email: "wronguser@domain.com")}
            before {sign_in user, no_capybara: true }
            describe "submitting a get request to users#edit action" do
                before {get edit_user_path(wrong_user)}
                specify { expect(response.body).not_to match(full_title('Edit user')) }
                specify { expect(response).to redirect_to(root_url) }
            end

            describe "submitting a patch request to users#update action" do
                before { patch user_path(wrong_user) }
                specify {expect(response).to redirect_to(root_url)}
            end
        end
        describe "for non-signed-in users" do
            let (:user) {FactoryGirl.create(:user)}
            describe "in the microposts controller" do
                describe "submitting to create action" do
                    before {post microposts_path}
                    specify { expect(response).to redirect_to(signin_path) }
                end
                describe "submitting to create action" do
                    before {delete micropost_path(FactoryGirl.create(:micropost))}
                    specify { expect(response).to redirect_to(signin_path) }
                end

            end
            describe "in the users controller" do
                describe "visiting the edit page" do
                    before {visit edit_user_path(user)}
                    it { should have_title('Sign in') }
                end
                describe "submitting to the update action" do
                     before {patch user_path(user)}
                     specify { expect(response).to redirect_to(signin_path) }
                end
                describe "visiting the user index page" do
                before { get users_path }
                specify { expect(response).to redirect_to(signin_path) }
#                specify { sign_in_content_validation(page) }
                    #before{ visit users_path }
                    #it { should have_title('Sign in') }
                    #specify { expect(response).to redirect_to(root_url) }
                end
            end
        end
    end

    describe "signin page" do
        before { visit signin_path }

        describe "with invalid information" do
            before { click_button "Sign in" }

            it { should have_title('Sign in') }
            it { should have_selector('div.alert.alert-error') }
            describe "after visiting another page" do
                before { click_link "Home" }
                it { should_not have_selector('div.alert.alert-error') }
            end
        end

        describe "with valid information" do
            let (:user) { FactoryGirl.create(:user) }
            before { sign_in user }
         
            it { should have_title(user.name) }
            it { should have_link('Users', href: users_path) }
            it { should have_link('Profile', href: user_path(user)) }
            it { should have_link('Settings', href: edit_user_path(user)) }
            it { should have_link('Sign out', href: signout_path) }
            it { should_not have_link('Sign in', href: signin_path) }
            
            describe "followed by signout" do
                before { click_link "Sign out" }
                it { should have_link("Sign in") } 
            end
        end
    end
end
