class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  before_action :verificate_user!

  private
  def redirect_based_on_login_status
    return unless current_user.nil?

    store_location
    flash[:danger] = 'Please log in.'
    redirect_to login_path
  end
end
