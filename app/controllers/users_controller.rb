class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user, only: :destroy
  before_filter :not_signedin, only: [:new, :create]

  def show
  	@user = User.find(params[:id])
  end

  def destroy
    user = User.find(params[:id]) 
    if current_user == user && current_user.admin?
      flash[:error] = "As an admin you are not able to destroy yourself"
    else
      user.destroy
      flash[:success] = "User destroyed."
    end
    redirect_to users_url
  end

  def new
  	@user = User.new
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def create
  	@user = User.new(params[:user])
  	if @user.save
      sign_in @user
  		flash[:success] = "Welcome to the sample App!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  private
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def not_signedin
      flash[:notify] = "You have already signed-up."
      redirect_to(root_path) unless !signed_in?
    end
end