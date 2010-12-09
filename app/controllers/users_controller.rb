class UsersController < ApplicationController
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => :destroy
  before_filter :already_in, :only => [:create, :new]

  def new
    @user = User.new
    @title = "Sign up"
  end

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end

  def show
    @user = User.find(params[:id])
    # we check her if the @user is !active so we can redirect and return
    # the 2nd check should be for signed-in but ! necessary here
    # as there is really no diff in displaying user profiles for signed and !signed-in
    # other actions would catch un-authorized accesses themselves
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      # everything begins here and some contradictions
      # in users_controller_spec.rb might occur if ! signed-in here
      # we need to change the logic of the test
      sign_in @user
      UserMailer.signup_confirmation(@user).deliver
      flash[:success] = "Welcome to Legacy Social Blog!"
      redirect_to @user
    else
      @title = "Sign up"
      render 'new'
    end
    rescue ActiveRecord::StatementInvalid
      redirect_to root_url
    rescue ActionController::InvalidAuthenticityToken
      warning = "ActionController::InvalidAuthenticityToken: #{params.inspect}"
      logger.warn warning
      redirect_to root_url
  end

  # email_verification links should be instrumented to
  # call an action here, user = SomeModel.find(params[:id])
  # if user.nil? flash[:error] and redirect to root_url
  # if user.active_state
  #    redirect_to root_url and return
  # else 
  #   user.active_state = true
  # redirect_to user

  def edit
    @title = "Edit user"
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:message] = "Profile updated."
      redirect_to @user
    else # fail close
      @title = "Edit user"
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    unless user.admin
      user.destroy
      flash[:success] = "User destroyed"
    end
    redirect_to users_path
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end

  private

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def already_in
    redirect_to(root_path) if signed_in?
  end
end
