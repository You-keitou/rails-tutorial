class UsersController < ApplicationController
  before_action :redirect_based_on_login_status, except: [:new, :create]
  before_action :redirect_based_on_logged_in_user, only: [:update, :edit]

  def new
    @user = User.new
  end

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = 'Welcome to the Sample App!'
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def redirect_based_on_login_status
    return unless current_user.nil?

    store_location
    flash[:danger] = 'Please log in.'
    redirect_to login_path
  end

  def redirect_based_on_logged_in_user
    return if params[:id].nil?

    user_requested = User.find(params[:id])
    return unless user_requested.id != current_user.id

    flash[:danger] = 'You are not allowed to access this page.'
    redirect_to root_url
  end
end
