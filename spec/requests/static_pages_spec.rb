require 'spec_helper'

describe "StaticPages" do
  
  let(:title_prefix) { "Ruby on Rails Tutorial Sample App" }
  
  describe "Home page" do
    
    it "should have the h1 'Sample App'" do
      visit '/static_pages/home'
      page.should have_selector('h1', :text => 'Sample App')
    end
    
    it "should have the title 'Home'" do
      visit '/static_pages/home'
      page.should have_selector('title', :text => "#{title_prefix} | Home")
    end
  end
  
  describe "Help page" do
    it "should have the h1 'Help'" do
      visit '/static_pages/help'
      page.should have_selector('h1', :text => 'Help')
    end
    
    it "should have the title 'Help'" do
      visit '/static_pages/help'
      page.should have_selector('title', :text => "#{title_prefix} | Help")
    end
  end
  
  describe "About page" do

    it "should have the h1 'About Us'" do
      visit '/static_pages/about'
      page.should have_selector('h1', :text => 'About Us')
    end
    
    it "should have the title 'About Us'" do
      visit '/static_pages/about'
      page.should have_selector('title', :text => "#{title_prefix} | About Us")
    end
  end
  
  describe "Contact page" do

    it "should have the h1 'Contact Us'" do
      visit '/static_pages/contact'
      page.should have_selector('h1', :text => 'Contact Us')
    end
    
    it "should have the title 'Contact Us'" do
      visit '/static_pages/contact'
      page.should have_selector('title', :text => "#{title_prefix} | Contact Us")
    end
  end
  
end
