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
end
