require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'new'" do

    before(:each) do
      get 'new'
    end

    it "should be successful" do
      response.should be_success
    end

    it "should have the right title" do
      response.should have_selector('title', :content => "Sign up")
    end

    it "should have a name field" do
      response.should have_selector("input[name='user[name]'][type='text']")
    end

    it "should have an email field" do
      response.should have_selector("input[name='user[email]'][type='text']")
    end

    it "should have a password field" do
      response.should have_selector("input[name='user[password]'][type='password']")
    end

    it "should have a password confirmation field" do
      response.should have_selector("input[name='user[password_confirmation]'][type='password']")
    end

  end

  describe "GET 'show'" do

    before(:each) do
      @user = Factory(:user)
    end

    it "should be successful" do
      get :show, :id => @user 
      response.should be_success
    end

    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user  
    end

    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end

    it "should include the user's name" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name)
    end

    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => "gravatar")
    end

    it "should show the user's microposts" do
      mp1 = Factory(:micropost, :user => @user, :content =>  "...a cornerstone in the place of honor.")
      mp2 = Factory(:micropost, :user => @user, :content => "Whoever trusts in this stone as a foundation
       will never have cause to regret it.")
       get :show, :id => @user
       response.should have_selector("span.content", :content => mp1.content)
       response.should have_selector("span.content", :content => mp2.content)
     end
  end

  describe "POST 'create'" do
    describe "failure" do

      before(:each) do
        @attr = {:name => "", :email => "", :password => "", 
                 :password_confirmation => "" }
      end

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Sign up")
      end

      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end

    describe "success" do

      before(:each) do
        @attr = {:name => "New User", :email => "sizesovers@yahoo.co.uk",
                 :password => "dedication", :password_confirmation => "dedication" }
      end

      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "should redirect to the user profile/show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end

      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to Legacy Social Blog/i
      end

      it "should sign a newly created user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
    end
  end

  describe "GET 'edit'" do

    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector("title", :content => "Edit user")
    end

    it "should have a link to change the gravat" do
      get :edit, :id => @user
      gravat_url = "http://gravatar.com/emails"
      response.should have_selector("a", :href => gravat_url,
                                         :content => "change") 
    end
  end

  describe "signed-in users" do

    before(:each) do
      user = Factory(:user)
      test_sign_in(user)
    end

    describe "GET 'new'" do

      it "should be redirected to root_path" do
        get :new
        response.should redirect_to(root_path)
      end
    end

    describe "POST 'create'" do

      it "should redirect to root_path" do
        post :create, :user => {:name => "New User", :email => "sizesovers@yahoo.co.uk",
                 :password => "dedication", :password_confirmation => "dedication" }
        response.should redirect_to(root_path)
      end
    end
  end

  describe "PUT 'update'" do

    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    describe "failure" do

      before(:each) do
        @attr = {:email => "", :name => "", :password => "",
                 :password_confirmation => ""}
      end

      it "should render the 'edit' page" do
        put :update, :id => @user, :user => @attr
        response.should render_template('edit')
      end

      it "should have the right title" do
        put :update, :id => @user, :user => @attr
        response.should have_selector("title", :content => "Edit user")
      end
    end

    describe "success" do

      before(:each) do
        @attr = {:name => "Evangelical", :email => "go@commission.org",
                 :password => "greatcomm", :password_confirmation => "greatcomm"}
      end

      it "should change the user's attributes" do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.name.should == @attr[:name]
        @user.email.should == @attr[:email]
      end

      it "should redirect to user show page" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to(user_path(@user))
      end

      it "should have a flash message" do
        put :update, :id => @user, :user => @attr
        flash[:success] =~ /updated/
      end
    end
  end

  describe "authentication of edit/update pages" do

    before(:each) do
      @user = Factory(:user)
    end

    describe "for non-signed-in users" do

      it "should deny access to 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
      end

      it "should deny access to 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(signin_path)
      end
    end

    describe "for signed-in users" do

      before(:each) do
        wrong_user = Factory(:user, :email => "user@example.net")
        test_sign_in(wrong_user)
      end

      it "should require matching users for 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end

      it "should require matching users for 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end
    end
  end

  describe "GET 'index'" do

    describe "for non-signed-in users" do
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end
    end

    describe "for signed-in users" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
        second = Factory(:user, :email => "another@example.com")
        third = Factory(:user, :email => "another@example.net")

        @users = [@user, second, third]
        30.times do
          @users << Factory(:user, :email => Factory.next(:email))
        end
      end
      
      it "should be successful" do
        get :index
        response.should be_success
      end

      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "All users")
      end

      it "should have an element for each user" do
        get :index
        @users[0..2].each do |user|
          response.should have_selector("li", :content => user.name)
        end
      end

      it "should paginate users" do
        get :index
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/users?page=2",
                                           :content => "2")
        response.should have_selector("a", :href => "/users?page=2",
                                           :content => "Next")
      end
    end
  end              

  describe "DELETE 'destroy'" do

    before(:each) do
      @user = Factory(:user)
    end

    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end
    end

    describe "as a non-admin user" do
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(root_path)
      end
    end

    describe "an admin user" do

      before(:each) do
        @admin = Factory(:user, :email => "admin@miraculous.org", :admin => true)
        @another_admin = Factory(:user, :email => "another@miraculous.org", :admin => true)
        test_sign_in(@admin)
      end

      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end

      it "should redirect to the users page" do
        delete :destroy, :id => @user
        response.should redirect_to(users_path)
      end

      describe "should not be able to delete other admins & himself" do

        it "should not delete himself" do
          lambda do
            delete :destroy, :id => @admin
          end.should_not change(User, :count)
        end

        it "should not delete another admin user" do
          lambda do
            delete :destroy, :id => @another_admin
          end.should_not change(User, :count)
        end
      end
    end
  end

  describe "testing the delete links" do

    before(:each) do
      @users = []
      10.times do
        @users << Factory(:user, :email => Factory.next(:email))
      end
    end

    describe "for normal users" do
    
      it "should not have a delete link" do
        @user = test_sign_in(@users[0])
        get :index
        @users.each do |user|
          response.should_not have_selector("a", :href => user_path(user),
                                                 :content => "delete")
        end
      end
    end

    describe "for admin users" do

      before(:each) do
        admin = Factory(:user, :email => "miraculous@turnarounds.com", :admin => true)
        admin_b = Factory(:user, :email => "blessing@perpetual.com", :admin => true)
        admin_c = Factory(:user, :email => "allround@turnarounds.com", :admin => true)
        test_sign_in(admin)
        @admins = [admin, admin_b, admin_c]
      end

      it "should have a delete link for each non-admin user" do
        get :index
        @users.each do |user|
          response.should have_selector("a", :href => user_path(user),
                                             :content => "delete")
        end
      end

      it "should not have delete links for all admin users" do
        get :index
        @admins.each do |admin|
          response.should_not have_selector("a", :href => user_path(admin),
                                                 :content => "delete")
        end
      end
    end
  end   

  describe "follow pages" do

    describe "when not signed in" do

      it "should protect 'following'" do
        get :following, :id => 1
        response.should redirect_to(signin_path)
      end

      it "should protect followers" do
        get :followers, :id => 1
        response.should redirect_to(signin_path)
      end
    end

    describe "when signed in" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
        @other_user = Factory(:user, :email => Factory.next(:email))
        @user.follow!(@other_user)
      end

      it "should show user following" do
        get :following, :id => @user
        response.should have_selector("a", :href => user_path(@other_user), 
                                           :content => @other_user.name)

      end

      it "should show user followers" do
        get :followers, :id => @other_user
        response.should have_selector("a", :href => user_path(@user),
                                           :content => @user.name)
      end
    end
  end
end
