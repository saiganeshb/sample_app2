require 'spec_helper'

describe "User pages" do

  subject { page }
  describe "signup" do
      before { visit signup_path }
      let(:submit) { "Create my account" }
      describe "with invalid info" do
          it "should not create a user" do
              expect {click_button submit}.not_to change(User, :count)
          end
      end

      describe "with valid info" do
          before do 
              fill_in "Name", with: "filled Name"
              fill_in "Email", with: "example@fromtest.com"
              fill_in "Password", with: "foobar"
              fill_in "Confirmation", with: "foobar"
          end
          it "should create a user" do
              expect { click_button submit }.to change(User, :count).by(1)
           end
          describe "after saving the user" do
              before { click_button submit }
              let (:user) {User.find_by(email: 'example@fromtest.com')}
              it { should have_link('Sign out') }
              it { should have_title(user.name) }
              it { should have_selector('div.alert.alert-success', text: 'Welcome') }

          end
      end

  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end
  describe "profile page" do
      let(:user) { FactoryGirl.create(:user) }
      before { visit user_path(user) }

      it { should have_content(user.name) }
      it { should have_title(user.name) }
  end
end
