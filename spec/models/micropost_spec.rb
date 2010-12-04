require 'spec_helper'

describe Micropost do

  before(:each) do
    @user = Factory(:user)
    @attr = {:content => "value for content" }
  end

  it "should create a new instance given valid attributes" do
    @user.microposts.create!(@attr)
  end

  describe "user associations" do

    before(:each) do
      @micropost = @user.microposts.create(@attr)
    end

    it "should have a user attribute" do
      @micropost.should respond_to(:user)
    end

    it "should be associated with the right user" do
      @micropost.user_id.should == @user.id
      @micropost.user.should == @user
    end
  end

  describe "validations" do

    it "should require a user_id" do
      Micropost.new(@attr).should_not be_valid
    end

    it "should reject long content" do
      @user.microposts.build(:content => 'p' * 141).should_not be_valid
    end
  end

  describe "from_users_followed_by" do

    before(:each) do
      @other_user = Factory(:user, :email => Factory.next(:email))
      @third_user = Factory(:user, :email => Factory.next(:email))

      @user_post = @user.microposts.create!(:content => "They're the ones who will be called on the carpet")
      @other_post = @other_user.microposts.create!(:content => "Friends, when life gets really")
      @third_post = @third_user.microposts.create!(:content => "It's judgment time for God's own family")

      @user.follow!(@other_user)
    end

    it "should have a from_users_followed_by class method" do
      Micropost.should respond_to(:from_users_followed_by)
    end

    it "should include the followed user's microposts" do
      Micropost.from_users_followed_by(@user).should include(@other_post)
    end

    it "should include the user's own microposts" do
      Micropost.from_users_followed_by(@user).should include(@user_post)
    end

    it "should not include an unfollowed user's micropost" do
      Micropost.from_users_followed_by(@user).should_not include(@third_post)
    end
  end    
end
