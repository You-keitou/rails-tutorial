class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user.present? && user.activated?
      flash[:success] = "Your account is already activated."
      redirect_to user
    elsif user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
