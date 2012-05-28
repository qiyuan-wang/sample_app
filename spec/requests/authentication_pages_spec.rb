require 'spec_helper'

describe "Authentication" do
    subject { page }
    
  describe "signin page" do
    before { visit signin_path }
    
    it { should have_selector('h1',    text: 'Sign in') }
    it { should have_selector('title', text: 'Sign in') }
  end
    
  describe "signin" do
    before { visit signin_path }  
    
    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { valid_signin user }
      
      it { should have_selector('title', text: user.name) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Users', href: users_path) }
      it { should have_link('Sign out', href: signout_path) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should_not have_link('Sign in', href: signin_path) }
      
      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end
    
    describe "with invalid information" do
      before { click_button 'Sign in' }
      
      it { should have_selector('title', text: 'Sign in') }
      it { should have_error_message('Invalid') }
      
      describe "after visit another page" do
        before { click_link 'Home' }
        
        it { should_not have_selector('div.alert.alert-error') }
      end
    end
  end
  
  describe "authentication" do
    
    describe "for none-sign-in users" do
      let(:user) { FactoryGirl.create(:user) }
      
      describe "in Users controller" do
        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          
          it { should have_selector('title', text: 'Sign in') }
        end
        describe "submitting to the update action" do
          before { put user_path(user) }
          
          specify { response.should redirect_to(signin_path) }
        end
        
        describe "visiting the user index" do
          before { visit users_path }
          
          it { should have_selector('title', text: 'Sign in') }
        end
      end
      
      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email", with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end
        
        describe "After sign in" do
          
          it { should have_selector('title', text:"Edit User") }
        end
      end
    end
    
    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }
      
      describe "Visiting User#edit page" do
        before { visit edit_user_path(wrong_user) }
        
        it { should_not have_selector('title', text: full_title('Edit User')) }
      end
      
      describe "submitting a PUT request to User#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end
    
    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }
      
      before { sign_in non_admin }
      
      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }
      end
    end
  end

end
