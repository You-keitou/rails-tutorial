class MicropostsController < ApplicationController
  before_action :redirect_based_on_login_status, except: []

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = 'Micropost created!'
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end

  def destroy
  end

  private
  def micropost_params
    params.require(:micropost).permit(:content)
  end
end
