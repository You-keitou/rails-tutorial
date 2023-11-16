class UsersController < ApplicationController
  before_action :redirect_based_on_login_status, except: [:new, :create]
  before_action :redirect_based_on_logged_in_user, only: [:update, :edit]
  before_action :redirect_based_on_admin, only: :delete

  def new
    @user = User.new
  end

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    return if @user.activated

    flash[:danger] = 'This user is not activated'
    redirect_to root_url
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = 'Please check your email to activate your account.'
      redirect_to root_url
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

  def destroy
    if User.find(params[:id]).destroy
      flash[:success] = 'User deleted'
      redirect_to users_path
    else
      flash[:danger] = 'Fail to delete user'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def redirect_based_on_logged_in_user
    return if params[:id].nil?

    user_requested = User.find(params[:id])
    return unless user_requested.id != current_user.id

    flash[:danger] = 'You are not allowed to access this page.'
    redirect_to root_url
  end

  def redirect_based_on_admin
    redirect_to(root_url) unless current_user.admin?
  end
end
