# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe User do

  before do
    @user = User.new(name:"nam",email:"namth90@yahoo.com",password:"123456",password_confirmation:"123456")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:password_reset_token) }
  it { should respond_to(:password_reset_send_at) }
  it { should respond_to(:microposts) }

  it { should be_valid }
  it { should_not be_admin }

  describe "with admin attributes set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

  describe "when name is not present" do 
  	before { @user.name = "" }
  	it { should_not be_valid }
  end

  describe "when email is not present" do 
  	before { @user.email = " " }
  	it { should_not be_valid }
  end

  describe "when name is too long" do 
  	before { @user.name = "a"*51 }
  	it { should_not be_valid }
  end

  describe "when email format is invalid" do
  	it "should be invalid" do
  		address = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
                     address.each do |invalid_address|
                     	@user.email = invalid_address
                     	should_not be_valid
                     end
  	end
  end

  describe "when email format is valid" do 
  	it "should be valid" do 
  		address = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
                     address.each do |valid_address|
                     	@user.email = valid_address
                     	should be_valid
                     end
  	end
  end

  describe "when email address is already taken" do
  	before do
  		user_with_same_email = @user.dup
  		# user_with_same_email = @user.email.upcase
  		user_with_same_email.save
  	end

  	it { should_not be_valid }
  end

  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "when password dosn't match confirmation" do 
    before { @user.password_confirmation = "abccdfd" }
    it { should_not be_valid }
  end

  describe "when password confirmation is nill" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "return values of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do 
      it { should == found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do 
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end

  describe "with a password that's too short" do 
    before { @user.password = @user.password_confirmation = "a"*6  }

    it { should_not be_invalid }
  end

  describe "remember token" do
    before { @user.save }

    its (:remember_token) { should_not be_blank }
  end

  describe "micropost associations" do

    before { @user.save }
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      @user.microposts.should == [newer_micropost,older_micropost]
    end
  end
end	
