class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :redirect_base_on_valid_user, except: [:new, :create]
  before_action :check_expiration, except: [:new, :create]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = 'Email sent with password reset instructions'
      redirect_to root_url
    else
      flash.now[:danger] = 'Email adress not found'
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update(user_params)
      log_in @user
      flash[:success] = 'Password has been reset.'
      redirect_to @user
    else
      render 'edit'
    end
  end
  private
    def user_params
      params.require(:user).permit(:password, :password_comfirmation)
    end
    # before filter
    def get_user
      @user = User.find_by(email: params[:email])
    end

    def redirect_base_on_valid_user
      unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = 'password reset has expired.'
        redirect_to new_password_reset_url
      end
    end
end
