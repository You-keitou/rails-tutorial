class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: user_params[:email].downcase)
    if user&.authenticate(user_params[:password])
      log_in user
      user_params[:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  private

  def user_params
    params.require(:session).permit(:email, :password, :remember_me)
  end
end
