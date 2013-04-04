require 'spec_helper'

describe "UserPages" do

# let(:base_title)  { "Ruby on Rails Tutorial Sample App" }

	subject { page }

  describe "signup_path" do
  	before { visit signup_path }
    it "should have the h1 'Sign Up'" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      	should have_selector('h1',:text=>"Sign Up")   		
    end
    it "should have the title 'Sign Up'" do 
    	should have_selector('title',:text => full_title("Sign Up"))
    end
  end

  describe "profile page" do 
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_selector('h1',    text: user.name) }
    it { should have_selector('title', text: user.name) }
  end

  describe "sign up" do

    before { visit signup_path }

    let(:submit){ "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User,:count)
      end

      describe "after submit" do
        before { click_button submit }

        it { should have_selector('title',:text => "Sign Up") }
        it { should have_selector('div.alert.alert-error',:text => "error") }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",                   with:"nam"
        fill_in "Email",                  with:"namth90@yahoo.com"
        fill_in "Password",               with:"123456"
        fill_in "Confirmation",  with:"123456"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User,:count).by(1)
      end

      describe "after submit" do
        before { click_button submit }
        let(:user) { User.find_by_email("namth90@yahoo.com") }

        it { should_not have_selector('title', :text => user.name) }
        it { should have_selector('div.alert.alert-success', :text => "Please") }
        # it { should have_link('default_url_options[:host]', :href => "localhost:3000") }
      end

      describe "after saving the user" do
        it { should_not have_link('have_link', href: signin_path) }
      end
    end
  end
end
