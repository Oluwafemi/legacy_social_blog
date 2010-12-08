require "spec_helper"

describe UserMailer do

  describe "sending emails" do

    before(:each) do
      @user = Factory(:user)
      @email = UserMailer.signup_confirmation(@user).deliver
    end

    it "should be delivered to the deliveries array" do
      ActionMailer::Base.deliveries.should include(@email)
    end

    describe "test the body of the sent email" do

      it "should match the subject and email" do
        #@user.email.should == @email.to
        "Thank you for signing up".should == @email.subject
      end
    end
  end
end
