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

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      signin_path user
      visit edit_user_path(user)
    end

    describe "page" do 
      it { should have_selector('h1',:text => "Update profile user") }
      it { should have_selector('title',:text => "Edit user") }
      it { should have_link('change',href: "http://gravatar.com/emails") }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }
      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name) { "nam" }
      let(:new_email) {"namth90@yahoo.com"}

      before do
        fill_in "Name",   with:new_name
        fill_in "Email",  with:new_email
        fill_in "Password", with:user.Password
        fill_in "Confirmation", with:user.Password
        click_button "Save changes"
      end

      it { should have_selector('title',text: new_name) }
      it { should have_selector('div.alert.alert.success') }
      it { should have_link('Sign out',href: signout_path) }
      specify { user.reload.name.should == new_name }
      specify { use.reload.email.should == new_email }
    end
  end

  describe "index" do
    # binding.pry
    before do 
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:user, name: "nam",email: "namth901@gmail.com")
      FactoryGirl.create(:user, name: "truong",email: "truongvv84@yahoo.com")    
      visit users_path
    end

    it { should have_selector('title',text:"All users") }
    it { should have_selector('h1',text:"All users") }

    it "should list each user" do
      User.all.each do |user|
        page.should have_selector('li',text:user.name)
      end
    end

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all) { User.delete_all }

      it { should have_selector('div.pagination') }

      
    end
  end
end
