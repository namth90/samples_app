require 'spec_helper'

describe Micropost do
  
  let(:user) { FactoryGirl.create(:user) }
  before do
  	@micopost = user.microposts.build(content: "bai viet hay")
  end

  subject { @micopost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }

  it { should be_valid }

  describe "when user_id is not present" do
  	before { @micopost.user_id = nil }
  	it { should_not be_valid }
  end

  describe "with blank content" do
  	before { @micopost.content = " " }
  	it { should_not be_valid }
  end

  describe "with content that is long too" do
  	before { @micopost.content = "a" * 141 }
  	it { should_not be_valid }
  end

  describe "accessible attributes" do
  	it "should not allow access to user_id" do
  		expect do
  			Micropost.new(user_id: user.id)
  		end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
  	end
  end
end
