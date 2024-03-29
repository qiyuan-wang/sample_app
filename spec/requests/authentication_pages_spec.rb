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
      before { sign_in user }
      
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
    
    describe "for sign-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }
      
      describe "in Users controller" do
        describe "try to access to create new user page" do
          before { get new_user_path }
          
          specify { response.should redirect_to(user_path(user)) }
        end
        
        describe "creating a new user" do
          before { post users_path }
          
          specify { response.should redirect_to(user_path(user)) }
        end
      end
    end
    
    describe "for none-sign-in users" do
      let(:user) { FactoryGirl.create(:user) }
      
      describe "in Users controller" do
        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          
          it { should have_selector('title', text: 'Sign in') }
          it { should_not have_link('Profile', href: user_path(user)) }
          it { should_not have_link('Users', href: users_path) }
          it { should_not have_link('Sign out', href: signout_path) }
          it { should_not have_link('Settings', href: edit_user_path(user)) }
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
      
      describe "in Relationships controller" do
        describe "submitting to create action" do
          before { post relationships_path }
          specify { response.should redirect_to(signin_path) }
        end
        
        describe "submitting to destroy action" do
          before { delete relationship_path(1) }
          specify { response.should redirect_to(signin_path) }
        end
      end
      
      describe "visiting the following page" do
        before { visit following_user_path(user) }
        
        it { should have_selector('title', text: 'Sign in') }
      end
      
      describe "visiting the follower page" do
        before { visit followers_user_path(user) }
        
        it { should have_selector('title', text: 'Sign in') }
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
          
          describe "when signing in again" do
            before do
              visit signin_path
              fill_in "Email",    with: user.email
              fill_in "Password", with: user.password
              click_button "Sign in"
            end

            it "should render the default (profile) page" do
              page.should have_selector('title', text: user.name) 
            end
          end
        end
      end
    end
    
    describe "in Microposts controller" do
      describe "submitting to the create action" do
        before { post microposts_path }
        specify { response.should redirect_to(signin_path) }
      end
        
      describe "submitting to the destroy action" do
        before { delete micropost_path(FactoryGirl.create(:micropost)) }
        specify { response.should redirect_to(signin_path) }
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
