class UsersController < ApplicationController
  before_action :redirect_to_based_on_login_status, except: [:new, :create]

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

    def redirect_to_based_on_login_status
      if current_user.nil?
        store_location
        flash[:danger] = 'Please log in.'
        redirect_to login_path
      else
        return if params[:id].nil?
        user_requested = User.find(params[:id])
        if user_requested.id != current_user.id
          flash[:danger] = "You are not allowed to access this page."
          redirect_to root_url
        end
      end
    end

end
