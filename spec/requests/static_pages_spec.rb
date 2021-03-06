require 'spec_helper'

describe "Static Pages" do

  # let(:base_title) { "Ruby on Rails Tutorial Sample App" }
  subject { page }

  describe "Home pages" do
    before { visit root_path }

  	it "should have the h1 'Sample App'" do
  		should have_selector('h1',:text => "Sample App")
  	end

  	it "should have the basic title" do
  		should have_selector('title', :text => full_title(''))
  	end

    it "should not have a custom page title" do
      should_not have_selector('title', :text => "Home")
    end
  end

  describe "Help page" do
    before { visit help_path }

  	it "should have the h1 'Help'" do
  		should have_selector('h1',:text => 'Help')
  	end

  	it "should have the title 'Help'" do
  		should have_selector('title', :text => full_title("Help"))
  	end
  end

  describe "About page" do
    before { visit about_path }

  	it "should have_content the h1 'About Us'" do  	
  		should have_selector('h1',:text => 'About Us')
  	end

  	it "should have the title 'About'" do
  		should have_selector('title', :text => full_title("About"))
  	end
  end

  describe "Contact page" do
    before { visit contact_path }

    it "should have the h1 'Contact'" do
      should have_selector('h1',:text => 'Contact')
    end

    it "should have title 'Contact'" do
      should have_selector('title',:text => full_title("Contact"))
    end
  end
end
